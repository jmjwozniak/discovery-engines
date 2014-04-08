#!/bin/zsh -eu

LOG=~wozniak/proj/d-e/logs/sync3.log
# LOG=/dev/stdout

mkdir -p $( dirname ${LOG} )

SITE1="wozniak#aps-detector:/~/G/bigdata"
SITE2="alcf#dtn_mira:/projects/ExM/DE"
# SITE3="wozniak#pads-c10:d-e.d"

GO_USER="wozniak"
GO=cli.globusonline.org
ACCT=${GO_USER}@${GO}

DELAY=60

# Sync on file size:
XFER_ARGS=( -r --preserve-mtime -s 1 )

date_word()
# 2006-10-13_14-26 : Good for file names
{
  date "+%Y-%m-%d_%H-%M"
}

{
while (( 1 ))
do
  print
  LABEL=( --label $( date_word ) )
  print "Starting sync: ${LABEL}"
  date
  ssh ${ACCT} scp ${XFER_ARGS} ${LABEL} ${SITE1} ${SITE2}
  # ssh ${ACCT} scp ${XFER_ARGS} ${LABEL} ${SITE2} ${SITE3}
  break
  sleep ${DELAY}
done < /dev/null
date
print DONE
} |& tee -a ${LOG}
