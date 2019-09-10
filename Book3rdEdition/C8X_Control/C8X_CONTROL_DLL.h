
// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the C8X_CONTROL_DLL_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// C8X_CONTROL_DLL_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.
#ifdef C8X_CONTROL_DLL_EXPORTS
#define C8X_CONTROL_DLL_API __declspec(dllexport)
#else
#define C8X_CONTROL_DLL_API __declspec(dllimport)
#endif

#include "winDSK8_stdtypes_win.h"
#include "DSP8_CCS4\\windsk8_enums.h"

extern "C" { // C name exports

// C8X_CONTROL_InitializeHostInterface must be called first
C8X_CONTROL_DLL_API bool   C8X_CONTROL_InitializeHostInterface(Uint32, ComSpeeds); 
C8X_CONTROL_DLL_API char * C8X_CONTROL_getVersionString();
C8X_CONTROL_DLL_API Uint32 C8X_CONTROL_getBoardVersion();

C8X_CONTROL_DLL_API bool   C8X_CONTROL_ResetAndRunCOFF(const Int8 *); 

C8X_CONTROL_DLL_API Int32  C8X_CONTROL_ResetDsp(void);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_LoadCOFF(const Int8 *);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_Run(); 

C8X_CONTROL_DLL_API bool   C8X_CONTROL_Write(Uint32, Uint32, Uint32*);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_Read(Uint32, Uint32, Uint32*);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_WriteFloat(Uint32, Uint32, float*);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_ReadFloat(Uint32, Uint32, float*);
C8X_CONTROL_DLL_API bool   C8X_CONTROL_GetSymbolValue(const char *, Uint32*);
}