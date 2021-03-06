/*
 * @(#)reda_buffer_impl.h    generated by: makeheader    Mon Dec  3 23:07:54 2007
 *
 *		built from:	buffer_impl.ifc
 */

#ifndef reda_buffer_impl_h
#define reda_buffer_impl_h


#ifdef __cplusplus
    extern "C" {
#endif



  #define REDABufferArray_getSize(answer, array, arrayCount) \
  { \
      register int i = 0; \
      for (*(answer) = 0; i < (arrayCount); ++i) { \
          *(answer) += ((array)[i]).length; \
      } \
  }

  #define REDABuffer_set(buf, ptr, len) \
  { \
      (buf)->length = (len); \
      (buf)->pointer = (ptr); \
  }

  #define REDABuffer_reset(buf) REDABuffer_set(buf, NULL, 0)


#ifdef __cplusplus
    }	/* extern "C" */
#endif

#endif /* reda_buffer_impl_h */
