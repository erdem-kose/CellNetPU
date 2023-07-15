#ifndef CNN_PACKAGE_H_
#define CNN_PACKAGE_H_
#include <math.h>

#define busM 6
#define busF 10
#define busWidth (busM+busF)
#define busUSMax (s64)(pow(2,busWidth)-1)
#define busMax (s64)(pow(2,(busWidth-1))-1)
#define busMin (s64)(-pow(2,(busWidth-1)))

#define errorM 22
#define errorF 10
#define errorWidth (errorM+errorF)
#define errorMax (s64)(pow(2,(errorWidth-1))-1)
#define errorMin (s64)(-pow(2,(errorWidth-1)))

#define modeWidth 2

#define ALUBorderTop (s64)pow(2,busF)
#define ALUBorderBottom (s64)(-pow(2,busF))

#define imageWidthMAX 128
#define imageHeightMAX 128

#define iterMAX busUSMax

#define patchWH 3
#define patchSize (s64)(pow(patchWH,2))
#define patchTop (patchWH-1)
#define patchBot 0

#define templateCount 50
#define templateWidth (patchSize*2+3)
#define templatePieces 5

#endif
