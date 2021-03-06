#!/bin/bash -eu

# RUN-REMOTE.SH

# Run this from Orthros to launch remote execution on the BG/Q
# You should already have a shared SSH session to REMOTE_HOST

usage()
{
  echo   ""
  echo   "run-remote.sh: usage: "
  echo   ""
  printf "\t run-remote.sh <LOCAL DATA DIRECTORY> <REMOTE DATA DIRECTORY> <PARAMETERS FILE NAME> <START> <STOP>\n"
  echo   ""
  echo   "Environment:"
  local W=-15 # Field width
  echo   ""
  printf "\t %${W}s Set the remote hostname\n"  REMOTE_HOST:
  printf "\t %${W}s Set the remote username\n"  REMOTE_USER:
  printf "\t %${W}s Set the script file\n"      REMOTE_SCRIPT:
  printf "\t %${W}s Set the data directory\n"   REMOTE_DATA:
  printf "\t %${W}s Set the parameters file\n"  REMOTE_PARAMS:
  echo   ""
}

if [[ ${#*} != 5 ]]
then
  usage
  exit 1
fi

set -x

DATA=$1             # E.g., /data/tomo1/NFTest/converted/Au_Reduced2
REMOTE_DATANAME=$2  # E.g., Au_Reduced2
PARAMETERS=$3       # E.g., ParametersGoldApril14.txt
START=$4
STOP=$5

DATA_ROOT=$( dirname $( dirname ${DATA} ) )
REMOTE_HOST=${REMOTE_HOST:-cetus.alcf.anl.gov}
REMOTE_USER=${REMOTE_USER:-wozniak}
REMOTE=${REMOTE_USER}@${REMOTE_HOST}
REMOTE_HOME=/home/${REMOTE_USER}
REMOTE_SCRIPT=${REMOTE_HOME}/proj/ppc64/d-e/nfhedm/swift/FitOrientation-T.sh
REMOTE_DATA=${REMOTE_HOME}/${REMOTE_DATANAME}
REMOTE_PARAMETERS=${REMOTE_DATA}/parameters.txt

# Extract parameters from parameters file
sed "s@DataDirectory.*@DataDirectory ${REMOTE_DATA}@" ${PARAMETERS} \
  > ${CONTROL_DIR}/parameters.txt
sed -i "s@ReducedFileName.*@ReducedFileName Au@" ${CONTROL_DIR}/parameters.txt

# Send the input data
cd ${DATA_ROOT}
FO_FILES=( grid.txt DiffractionSpots.txt Key.txt OrientMat.txt )
rsync -a --stats ${FO_FILES[@]} ${REMOTE}:${REMOTE_DATA}
cd ${CONTROL_DIR}
rsync -az --stats ${DATA}/ parameters.txt ${REMOTE}:${REMOTE_DATA}

# Execute Swift/T remotely
REMOTE_LOG=${CONTROL_DIR}/remote.log
REMOTE_PARAMS=${REMOTE_DATA}/parameters.txt
ssh ${REMOTE} ${REMOTE_SCRIPT} \
  ${REMOTE_DATA} ${REMOTE_PARAMS} ${START} ${STOP} >& \
  ${REMOTE_LOG}

# Extract Swift/T output directory:
TURBINE_OUTPUT_LINE=$( grep TURBINE_OUTPUT ${REMOTE_LOG} )
eval ${TURBINE_OUTPUT_LINE}
# Retrieve output data:
rsync -az ${REMOTE}:${TURBINE_OUTPUT}/ .
rsync -az ${REMOTE}:${REMOTE_DATA}/microstructure.mic .
