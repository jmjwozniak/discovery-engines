
#include <assert.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <limits.h>
#include <sys/stat.h>
#include <string.h>
#include <ctype.h>
#include <nlopt.h>
#include <stdint.h>

#include "Debug.h"
#include "SharedFuncsFit.h"
#include "FitOrientation.h"

#define RealType double
#define float32_t float
#define SetBit(A,k)   (A[(k/32)] |=  (1 << (k%32)))
#define ClearBit(A,k) (A[(k/32)] &= ~(1 << (k%32)))
#define TestBit(A,k)  (A[(k/32)] &   (1 << (k%32)))
#define deg2rad 0.0174532925199433
#define rad2deg 57.2957795130823
#define EPS 1E-5
#define MAX_N_SPOTS 200
#define MAX_N_OMEGA_RANGES 20

static void
usage()
{
    printf("usage: fo-nlopt <PARAMETERS> <GRID-POINT-NUMBER> <MICROSTRUCTURE>\n");
}

int
main(int argc, char *argv[])
{
    if (argc < 4)
    {
        usage();
        return EXIT_FAILURE;
    }

    printf("setvbuf...\n");
    setvbuf(stdout, NULL, _IONBF, 0);
    
    // Read params file.
    char *ParamFN = argv[1];
    //Read position.
    int rown=atoi(argv[2]);
    char *MicrostructureFN = argv[3];

    bool result = FitOrientationAll(ParamFN, rown, MicrostructureFN);
    if (!result)
    {
        printf("FitOrientation failed!\n");
        exit(EXIT_FAILURE);
    }

    PROFILE_REPORT;
    return EXIT_SUCCESS;
}
