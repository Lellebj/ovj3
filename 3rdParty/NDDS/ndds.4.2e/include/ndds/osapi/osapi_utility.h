/*
 * @(#)osapi_utility.h    generated by: makeheader    Mon Dec  3 23:07:48 2007
 *
 *		built from:	utility.ifc
 */

#ifndef osapi_utility_h
#define osapi_utility_h


  #ifndef osapi_type_h
    #include "osapi/osapi_type.h"
  #endif
  #ifndef osapi_dll_h
    #include "osapi/osapi_dll.h"
  #endif

#ifdef __cplusplus
    extern "C" {
#endif

extern RTIOsapiDllExport int RTIOsapiUtility_max(int l, int r);

extern RTIOsapiDllExport int RTIOsapiUtility_isWithinBound(
    int me, int lower, int upper);

extern RTIOsapiDllExport int RTIOsapiUtility_min(int l, int r);

extern RTIOsapiDllExport RTI_UINT32 RTIOsapiUtility_ntohl(RTI_UINT32 l);

extern RTIOsapiDllExport short RTIOsapiUtility_htons(short s);

extern RTIOsapiDllExport int RTIOsapiUtility_isDigit(int c);

extern RTIOsapiDllExport 
char* RTIOsapi_envVarOrFileGet(char *buffer, int bufferLen,
                                 const char *envVariableName,
                                 const char *fileName,
                                 char separator, 
                                 char commentchar);

extern RTIOsapiDllExport
RTIBool RTIOsapi_envVarSet(char * envVariable);

extern RTIOsapiDllExport
int RTIOsapiUtility_snprintf(char *str, int size, const char *format, ...);


#define RTI_OSAPI_STRING_SEQ_STRING_MAX_SIZE (4096)


#ifdef __cplusplus
    }	/* extern "C" */
#endif

  #include "osapi/osapi_utility_impl.h"

#endif /* osapi_utility_h */