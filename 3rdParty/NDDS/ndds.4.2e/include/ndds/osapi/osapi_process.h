/*
 * @(#)osapi_process.h    generated by: makeheader    Mon Dec  3 23:07:48 2007
 *
 *		built from:	process.ifc
 */

#ifndef osapi_process_h
#define osapi_process_h


  #ifndef osapi_type_h
    #include "osapi/osapi_type.h"
  #endif
  #ifndef osapi_dll_h
    #include "osapi/osapi_dll.h"
  #endif

#ifdef __cplusplus
    extern "C" {
#endif

extern RTIOsapiDllExport RTI_UINT32 RTIOsapiProcess_getId();

extern RTIOsapiDllExport RTIBool RTIOsapiProcess_isAlive(RTI_UINT32 pidIn);


#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* osapi_process_h */