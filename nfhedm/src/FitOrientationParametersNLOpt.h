/*
 * FitOrientationParametersNLOpt.h
 *
 *  Created on: Mar 6, 2014
 *      Author: wozniak
 */

#ifndef FITORIENTATIONPARAMETERSNLOPT_H
#define FITORIENTATIONPARAMETERSNLOPT_H


void
NormalizeMat(
    double OMIn[9],
    double OMOut[9]);

void
CalcFracOverlap(
    const int NrOfFiles,
    const int nLayers,
    const int nTspots,
    double TheorSpots[MAX_N_SPOTS][3],
    double OmegaStart,
    double OmegaStep,
    double XGrain[3],
    double YGrain[3],
    const double Lsds[nLayers],
    const long long int SizeObsSpots,
    double RotMatTilts[3][3],
    const double px,
    const double ybcs[nLayers],
    const double zbcs[nLayers],
    const double gs,
    double P0All[nLayers][3],
    const int NrPixelsGrid,
    const int ObsSpotsInfo[SizeObsSpots],
    double OrientMatIn[3][3],
    double *FracOver);

void
optimizeOrientation(double *OrientMatrixRow,
                    double tx, double ty, double tz, int nLayers,
                    int nrFiles, int *ObsSpotsInfo,
                    double LatticeConstant, double Wavelength, int nRings,
                    double ExcludePoleAngle, double *Lsd, int SizeObsSpots,
                    double OmegaStart, double OmegaStep, double px, double *ybc, double *zbc,
                    double gs, /*18*/int *RingNumbers, /*19*/double OmegaRanges[MAX_N_OMEGA_RANGES][2],
                    int NoOfOmegaRanges,
                    /*21*/double BoxSizes[MAX_N_OMEGA_RANGES][4], double P0[nLayers][3], int NrPixelsGrid,
                    double tol, double lsdtol, double lsdtolrel,
                    double tiltstol,double bctola, double bctolb, double *output, int outputMax);

void
RotationTilts(
    double tx,
    double ty,
    double tz,
    double RotMatOut[3][3]);

#endif
