PROJNAME = im
LIBNAME = imlua_jp2
DEF_FILE = imlua_jp2.def

OPT = YES

SRCDIR = lua5

SRC = imlua_jp2.c

LIBS = im_jp2

INCLUDES = lua5

ifdef USE_LUA_VERSION
  USE_LUA51:=
  USE_LUA52:=
  USE_LUA53:=
  ifeq ($(USE_LUA_VERSION), 53)
    USE_LUA53:=Yes
  endif
  ifeq ($(USE_LUA_VERSION), 52)
    USE_LUA52:=Yes
  endif
  ifeq ($(USE_LUA_VERSION), 51)
    USE_LUA51:=Yes
  endif
endif

ifdef USE_LUA53
  LUA_VER = 5.3
  LUASFX = 53
else
ifdef USE_LUA52
  LUA_VER = 5.2
  LUASFX = 52
else
  LUA_VER = 5.1
  USE_LUA51 = Yes
  LUASFX = 51
endif
endif

LIBNAME := $(LIBNAME)$(LUASFX)

USE_IMLUA = Yes
# To not link with the Lua dynamic library in UNIX
NO_LUALINK = Yes
# To use a subfolder with the Lua version for binaries
LUAMOD_DIR = Yes
IM = ..

ifneq ($(findstring MacOS, $(TEC_UNAME)), )
  USE_IMLUA:=
  INCLUDES += ../include
  LDIR = ../lib/$(TEC_UNAME)
endif
