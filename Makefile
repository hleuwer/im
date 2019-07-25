# Installation items
APPS = $(shell cat apps.list)
SLIBS = $(shell cat slib.list)
DLIBS = $(shell cat dlib.list)
INCS = $(shell cat inc.list)

# Install destinations
INSTALL_DIR = /usr/local
INSTALL_BINDIR = $(INSTALL_DIR)/bin
INSTALL_LIBDIR = $(INSTALL_DIR)/lib
INSTALL_MODDIR = $(INSTALL_DIR)/lib/lua
INSTALL_INCDIR = $(INSTALL_DIR)/include

TEC_UNAME=$(shell ls lib)

.PHONY: do_all

do_all:
	@$(MAKE) --no-print-directory -C ./src/ do_all

.PHONY: clean clean-target clean-obj install install-app install-slib install-dlib install-mod uninstall install-list

clean clean-target clean-obj:
	for i in $(SUBDIRS); \
	do \
	  cd $$i; $(MAKE)  -f ../tecmake.mak $@; cd ..; \
	done

install: install-app install-slib install-dlib install-mod install-inc

install-inc: inc.list
	@echo "Installing headers ..."
	@mkdir -p $(INSTALL_INCDIR)/im
	@for i in $(INCS); do cp -f include/$$i $(INSTALL_INCDIR)/im; done

install-app: apps.list
	@echo "Installing applications ..."
	@for i in $(APPS); do cp -f $$i $(INSTALL_BINDIR); done

install-slib: slib.list
	@echo "Installing static libraries ..."
	@for i in $(SLIBS); do cp -f $$i $(INSTALL_LIBDIR); done

install-dlib: dlib.list
	@echo "Installing dynamic libraries ..."
	@for i in $(DLIBS); do cp -f $$i $(INSTALL_LIBDIR); done

install-mod: mods52.list mods53.list
	@echo "Installing Lua modules ..."
#	@mkdir -p $(INSTALL_MODDIR)/5.1
#	@for i in $(shell cat mods51.list); do \
#		cp -f lib/$(TEC_UNAME)/Lua51/lib$$i $(INSTALL_LIBDIR)/lib$$i; \
#		ln -f -s $(INSTALL_LIBDIR)/lib$$i $(INSTALL_MODDIR)/5.1/$$i; \
#	done
	@mkdir -p $(INSTALL_MODDIR)/5.2
	@for i in $(shell cat mods52.list); do \
		cp -f lib/$(TEC_UNAME)/Lua52/lib$$i $(INSTALL_LIBDIR)/lib$$i; \
		ln -f -s $(INSTALL_LIBDIR)/lib$$i $(INSTALL_MODDIR)/5.2/$$i; \
	done
	@mkdir -p $(INSTALL_MODDIR)/5.3
	@for i in $(shell cat mods53.list); do \
		cp -f lib/$(TEC_UNAME)/Lua53/lib$$i $(INSTALL_LIBDIR)/lib$$i; \
		ln -f -s $(INSTALL_LIBDIR)/lib$$i $(INSTALL_MODDIR)/5.3/$$i; \
	done

install-list:
	@echo "Generating installation item lists ..."
	@ls include > inc.list
ifeq (Linux, $(TEC_SYSNAME))
	@find . -name "*.so" > dlib.list
endif
ifeq (MacOS, $(TEC_SYSNAME))
	@find . -name "*.dylib" > dlib.list
endif
#	@cd lib/$(TEC_UNAME)/Lua51 && ls *.so | sed -s s/lib//1 > ../../../mods51.list
	@cd lib/$(TEC_UNAME)/Lua52 && ls *.so | sed -s s/lib//1 > ../../../mods52.list
	@cd lib/$(TEC_UNAME)/Lua53 && ls *.so | sed -s s/lib//1 > ../../../mods53.list
	@find . -name "*.a" > slib.list
	@echo > apps.list
#	@find bin/$(TEC_UNAME) -type f > apps.list

uninstall-app:
	@for i in $(APPS); do rm $(INSTALL_BINDIR)/`basename $$i`; done

uninstall-slib:
	@for i in $(SLIBS); do rm $(INSTALL_LIBDIR)/`basename $$i`; done

uninstall-dlib:
	@for i in $(DLIBS); do rm $(INSTALL_LIBDIR)/`basename $$i`; done

uninstall-mod:
	@for i in $(shell cat mods51.list); do rm $(INSTALL_MODDIR)/5.1/$$i $(INSTALL_LIBDIR)/lib$$i; done
	@for i in $(shell cat mods52.list); do rm $(INSTALL_MODDIR)/5.2/$$i $(INSTALL_LIBDIR)/lib$$i; done
	@for i in $(shell cat mods53.list); do rm $(INSTALL_MODDIR)/5.3/$$i $(INSTALL_LIBDIR)/lib$$i; done
