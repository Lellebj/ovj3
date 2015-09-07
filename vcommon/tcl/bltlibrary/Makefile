# Generated automatically from Makefile.in by configure.
# ------------------------------------------------------------------------
# 	Makefile for library files and directories of BLT library
# ------------------------------------------------------------------------

prefix       = /usr/local
exec_prefix  = /usr/local
version      = 2.4
srcdir       = .
libdir       = $(exec_prefix)/lib
scriptdir    = $(prefix)/lib/blt$(version)
AUX_LIBS     = 

INSTALL      = ../cf/install-sh -c
INSTALL_DATA = ${INSTALL} -m 644
RM           = rm -f
SHELL        = /bin/sh

miscFiles     = bltCanvEps.pro bltGraph.pro \
		bltDnd.tcl bltDragdrop.tcl \
		bltGraph.tcl bltHierbox.tcl bltHiertable.tcl \
		bltTabnotebook.tcl bltTabset.tcl \
		tclIndex htresize.xbm htresize_m.xbm

ddFiles      = dd-color.tcl dd-file.tcl dd-number.tcl dd-text.tcl tclIndex

instdirs     = $(prefix) $(exec_prefix) $(libdir) $(scriptdir) \
		$(scriptdir)/dd_protocols

all: pkgIndex

install: mkdirs dragdrop files package

mkdirs:
	@for i in $(instdirs) ; do \
	    if test -d $$i ; then : ; else mkdir $$i ; fi ; \
        done

dragdrop: mkdirs
	for i in $(ddFiles) ; do \
	    $(INSTALL_DATA) $(srcdir)/dd_protocols/$$i $(scriptdir)/dd_protocols ; \
	done 

files: mkdirs
	for i in $(miscFiles) ; do \
	    $(INSTALL_DATA) $(srcdir)/$$i $(scriptdir) ; \
	done 

package: mkdirs pkgIndex.tcl
	$(INSTALL_DATA) pkgIndex.tcl $(scriptdir)

pkgIndex: 
	rm -f pkgIndex.tcl
	sed -e 's/__VERSION__/$(version)/' $(srcdir)/pkgIndex.tcl.in | \
	sed -e 's;__LIB_DIR__;$(libdir);' | \
	sed -e 's;__AUX_LIBS__;$(AUX_LIBS);' > pkgIndex.tcl
clean:
	$(RM) pkgIndex.tcl

distclean: clean
	$(RM) $(srcdir)/*.bak $(srcdir)/*\~ $(srcdir)/"#"* Makefile
