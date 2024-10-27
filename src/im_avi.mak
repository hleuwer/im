PROJNAME = im
LIBNAME = im_avi
OPT = YES

SRC = im_format_avi.cpp
                                       
LIBS = vfw32

USE_IM=Yes
IM = ..

ifneq ($(findstring cygw, $(TEC_UNAME)), )
  $(error No support for AVI in Cygwin when using Posix mode)
endif

ifneq ($(findstring MacOS, $(TEC_UNAME)), )
  BUILD_DYLIB=Yes
endif
