# Copyright (c) 2015-2016, 2018, 2020-2022 Paul Mattes.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Paul Mattes nor his contributors may be used
#       to endorse or promote products derived from this software without
#       specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY PAUL MATTES "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
# NO EVENT SHALL PAUL MATTES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Top-level Makefile for suite3270.

all:  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback

# Cleverness for 'make targets':
#  UNIX is true if there is at least one Unix target
#  MIXED is true if there is at least one Unix target and at least one Windows
#   target
#  M1 is true if there is more than one target
UNIX := $(shell (echo  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback | grep -q '\<[^w]') && echo true)
MIXED := $(shell (echo  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback | grep -q '\<[^w]') && (echo  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback | grep -q '\<[w]') && echo true)
M1 := $(shell test `echo  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback | wc -w` -gt 1 && echo true)

# List targets
targets:
	@echo "Targets:"
	@echo " all                  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback"
ifdef MIXED
	@echo "  unix                build all Unix programs"
	@echo "  windows             build all Windows programs"
endif
	@echo "  lib                 build all libraries"
ifdef MIXED
	@echo "  unix-lib            build all Unix libraries"
	@echo "  windows-lib         build all Windows libraries"
endif
ifdef M1
	@echo "  <program>           build <program>"
endif
	@echo " install              install programs"
	@echo " install.man          install man pages"
	@echo " clean                remove all intermediate files"
ifdef MIXED
	@echo "  unix-clean          remove Unix intermediate files"
	@echo "  windows-clean       remove Windows intermediate files"
endif
	@echo "  lib-clean           remove library intermediate files"
ifdef MIXED
	@echo "  unix-lib-clean      remove Unix library intermediate files"
	@echo "  windows-lib-clean   remove Windows library intermediate files"
endif
ifdef M1
	@echo "  <program>-clean     remove <program> intermediate files"
endif
	@echo " clobber              remove all derived files"
ifdef MIXED
	@echo "  unix-clobber        remove Unix derived files"
	@echo "  windows-clobber     remove Windows derived files"
endif
	@echo "  lib-clobber         remove library derived files"
ifdef MIXED
	@echo "  unix-lib-clobber    remove Unix library derived files"
	@echo "  windows-lib-clobber remove Windows library derived files"
endif
ifdef M1
	@echo "  <program>-clobber   remove <program> derived files"
endif
ifdef UNIX
	@echo " test                 run unit and integration tests"
	@echo "  smoketest           run smoke tests"
	@echo "  unix-lib-test       run Unix library tests"
ifdef M1
	@echo "  <program>-test      run <program> tests"
endif
endif

# Library ependencies.
c3270 s3270 b3270 tcl3270 x3270 pr3287: unix-lib
wc3270 ws3270 wb3270 wpr3287: windows-lib

# x3270if dependencies.
c3270 s3270 b3270 tcl3270 x3270: x3270if
wc3270 ws3270 wb3270: wx3270if

.PHONY: x3270if

# s3270 dependencies.
tcl3270: s3270

.PHONY: s3270

.PHONY: playback

# Individual targets.
unix-lib: lib3270 lib3270i lib32xx lib3270stubs
windows-lib: libw3270 libw3270i libw32xx libw3270stubs libexpat
lib:  unix-lib
lib3270:
	cd lib/3270 && $(MAKE)
lib3270i:
	cd lib/3270i && $(MAKE)
lib32xx:
	cd lib/32xx && $(MAKE)
lib3270stubs:
	cd lib/3270stubs && $(MAKE)
libw3270: libw3270-32 libw3270-64
libw3270-32:
	cd lib/w3270 && $(MAKE)
libw3270-64:
	cd lib/w3270 && $(MAKE) WIN64=1
libw3270i: libw3270i-32 libw3270i-64
libw3270i-32:
	cd lib/w3270i && $(MAKE)
libw3270i-64:
	cd lib/w3270i && $(MAKE) WIN64=1
libw32xx: libw32xx-32 libw32xx-64
libw32xx-32:
	cd lib/w32xx && $(MAKE)
libw32xx-64:
	cd lib/w32xx && $(MAKE) WIN64=1
libw3270stubs: libw3270stubs-32 libw3270stubs-64
libw3270stubs-32:
	cd lib/w3270stubs && $(MAKE)
libw3270stubs-64:
	cd lib/w3270stubs && $(MAKE) WIN64=1
libexpat: libexpat-32 libexpat-64
libexpat-32:
	cd lib/libexpat && $(MAKE)
libexpat-64:
	cd lib/libexpat && $(MAKE) WIN64=1
c3270: lib3270 lib3270i lib32xx
	cd c3270 && $(MAKE)
s3270: lib3270 lib32xx
	cd s3270 && $(MAKE)
b3270: lib3270 lib32xx
	cd b3270 && $(MAKE)
tcl3270: lib3270 lib32xx
	cd tcl3270 && $(MAKE)
x3270: lib3270 lib3270i lib32xx
	cd x3270 && $(MAKE)
pr3287: lib32xx
	cd pr3287 && $(MAKE)
x3270if:
	cd x3270if && $(MAKE)
playback: lib3270 lib32xx
	cd playback && $(MAKE)
wc3270: wc3270-32 wc3270-64
wc3270-32: libw3270-32 libw3270i-32 libw32xx-32
	cd wc3270 && $(MAKE) 
wc3270-64: libw3270-64 libw3270i-64 libw32xx-64
	cd wc3270 && $(MAKE) WIN64=1 
ws3270: ws3270-32 ws3270-64
ws3270-32: libw3270-32 libw32xx-32
	cd ws3270 && $(MAKE) 
ws3270-64: libw3270-64 libw32xx-64
	cd ws3270 && $(MAKE) WIN64=1 
wb3270: wb3270-32 wb3270-64
wb3270-32: libw3270-32 libw32xx-32
	cd wb3270 && $(MAKE) 
wb3270-64: libw3270-64 libw32xx-64
	cd wb3270 && $(MAKE) WIN64=1 
wpr3287: wpr3287-32 wpr3287-64
wpr3287-32: libw32xx-32
	cd wpr3287 && $(MAKE) 
wpr3287-64: libw32xx-64
	cd wpr3287 && $(MAKE) WIN64=1 
wx3270if: wx3270if-32 wx3270if-64
wx3270if-32:
	cd wx3270if && $(MAKE) 
wx3270if-64:
	cd wx3270if && $(MAKE) WIN64=1 
wplayback: wplayback-32 wplayback-64
wplayback-32: libw3270-32 libw32xx-32
	cd wplayback && $(MAKE) 
wplayback-64: libw3270-64 libw32xx-64
	cd wplayback && $(MAKE) WIN64=1 

FORCE:

unix:  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if playback
windows: 

# Installation
install unix-install:  x3270-install c3270-install s3270-install b3270-install tcl3270-install pr3287-install x3270if-install
x3270-install: x3270
	cd x3270 && $(MAKE) install
c3270-install: c3270
	cd c3270 && $(MAKE) install
s3270-install: s3270
	cd s3270 && $(MAKE) install
b3270-install: b3270
	cd b3270 && $(MAKE) install
tcl3270-install: tcl3270
	cd tcl3270 && $(MAKE) install
pr3287-install: pr3287
	cd pr3287 && $(MAKE) install
x3270if-install: x3270if
	cd x3270if && $(MAKE) install

# Manual page install
install.man unix-install.man:  x3270-install.man c3270-install.man s3270-install.man b3270-install.man tcl3270-install.man pr3287-install.man x3270if-install.man
x3270-install.man: x3270
	cd x3270 && $(MAKE) install.man
c3270-install.man: c3270
	cd c3270 && $(MAKE) install.man
s3270-install.man: s3270
	cd s3270 && $(MAKE) install.man
b3270-install.man: b3270
	cd b3270 && $(MAKE) install.man
tcl3270-install.man: tcl3270
	cd tcl3270 && $(MAKE) install.man
pr3287-install.man: pr3287
	cd pr3287 && $(MAKE) install.man
x3270if-install.man: x3270if
	cd x3270if && $(MAKE) install.man

# Clean and clobber targets
clean:  x3270-clean c3270-clean s3270-clean b3270-clean tcl3270-clean pr3287-clean x3270if-clean playback-clean unix-lib-clean
unix-lib-clean: lib3270-clean lib3270i-clean lib32xx-clean lib3270stubs-clean
windows-lib-clean: libw3270-clean libw3270i-clean libw32xx-clean libw3270stubs-clean libexpat-clean
lib-clean:  unix-lib-clean
unix-clean:  x3270-clean c3270-clean s3270-clean b3270-clean tcl3270-clean pr3287-clean x3270if-clean unix-lib-clean
windows-clean: 
lib3270-clean:
	cd lib/3270 && $(MAKE) clean && $(MAKE) -f Makefile.test clean
lib3270i-clean:
	cd lib/3270i && $(MAKE) clean
lib32xx-clean:
	cd lib/32xx && $(MAKE) clean && $(MAKE) -f Makefile.test clean
lib3270stubs-clean:
	cd lib/3270stubs && $(MAKE) clean
libw3270-clean: libw3270-clean-32 libw3270-clean-64
libw3270-clean-32:
	cd lib/w3270 && $(MAKE) clean && $(MAKE) -f Makefile.test clean
libw3270-clean-64:
	cd lib/w3270 && $(MAKE) clean WIN64=1 && $(MAKE) -f Makefile.test clean WIN64=1
libw3270i-clean: libw3270i-clean-32 libw3270i-clean-64
libw3270i-clean-32:
	cd lib/w3270i && $(MAKE) clean
libw3270i-clean-64:
	cd lib/w3270i && $(MAKE) clean WIN64=1
libw32xx-clean: libw32xx-clean-32 libw32xx-clean-64
libw32xx-clean-32:
	cd lib/w32xx && $(MAKE) clean && $(MAKE) -f Makefile.test clean
libw32xx-clean-64:
	cd lib/w32xx && $(MAKE) clean WIN64=1 && $(MAKE) -f Makefile.test clean WIN64=1
libw3270stubs-clean: libw3270stubs-clean-32 libw3270stubs-clean-64
libw3270stubs-clean-32:
	cd lib/w3270stubs && $(MAKE) clean
libw3270stubs-clean-64:
	cd lib/w3270stubs && $(MAKE) clean WIN64=1
libexpat-clean: libexpat-clean-32 libexpat-clean-64
libexpat-clean-32:
	cd lib/libexpat && $(MAKE) clean
libexpat-clean-64:
	cd lib/libexpat && $(MAKE) clean WIN64=1
x3270-clean:
	cd x3270 && $(MAKE) clean
c3270-clean:
	cd c3270 && $(MAKE) clean
s3270-clean:
	cd s3270 && $(MAKE) clean
b3270-clean:
	cd b3270 && $(MAKE) clean
tcl3270-clean:
	cd tcl3270 && $(MAKE) clean
pr3287-clean:
	cd pr3287 && $(MAKE) clean
x3270if-clean:
	cd x3270if && $(MAKE) clean
playback-clean:
	cd playback && $(MAKE) clean
wc3270-clean: wc3270-clean-32 wc3270-clean-64
wc3270-clean-32:
	cd wc3270 && $(MAKE) clean
wc3270-clean-64:
	cd wc3270 && $(MAKE) clean WIN64=1
ws3270-clean: ws3270-clean-32 ws3270-clean-64
ws3270-clean-32:
	cd ws3270 && $(MAKE) clean
ws3270-clean-64:
	cd ws3270 && $(MAKE) clean WIN64=1
wb3270-clean: wb3270-clean-32 wb3270-clean-64
wb3270-clean-32:
	cd wb3270 && $(MAKE) clean
wb3270-clean-64:
	cd wb3270 && $(MAKE) clean WIN64=1
wx3270if-clean: wx3270if-clean-32 wx3270if-clean-64
wx3270if-clean-32:
	cd wx3270if && $(MAKE) clean
wx3270if-clean-64:
	cd wx3270if && $(MAKE) clean WIN64=1
wplayback-clean: wplayback-clean-32 wplayback-clean-64
wplayback-clean-32:
	cd wplayback && $(MAKE) clean
wplayback-clean-64:
	cd wplayback && $(MAKE) clean WIN64=1

clobber:  x3270-clobber c3270-clobber s3270-clobber b3270-clobber tcl3270-clobber pr3287-clobber x3270if-clobber playback-clobber unix-lib-clobber
unix-lib-clobber: lib3270-clobber lib3270i-clobber lib32xx-clobber lib3270stubs-clobber
windows-lib-clobber: libw3270-clobber libw3270i-clobber libw32xx-clobber libw3270stubs-clobber libexpat-clobber
lib-clobber:  unix-lib-clobber
unix-clobber:  x3270-clobber c3270-clobber s3270-clobber b3270-clobber tcl3270-clobber pr3287-clobber x3270if-clobber unix-lib-clobber
windows-clobber: 
lib3270-clobber:
	cd lib/3270 && $(MAKE) clobber && $(MAKE) -f Makefile.test clobber
lib3270i-clobber:
	cd lib/3270i && $(MAKE) clobber
lib32xx-clobber:
	cd lib/32xx && $(MAKE) clobber && $(MAKE) -f Makefile.test clobber
lib3270stubs-clobber:
	cd lib/3270stubs && $(MAKE) clobber
libw3270-clobber: libw3270-clobber-32 libw3270-clobber-64
libw3270-clobber-32:
	cd lib/w3270 && $(MAKE) clobber
libw3270-clobber-64:
	cd lib/w3270 && $(MAKE) clobber WIN64=1
libw3270i-clobber: libw3270i-clobber-32 libw3270i-clobber-64
libw3270i-clobber-32:
	cd lib/w3270i && $(MAKE) clobber
libw3270i-clobber-64:
	cd lib/w3270i && $(MAKE) clobber WIN64=1
libw32xx-clobber: libw32xx-clobber-32 libw32xx-clobber-64
libw32xx-clobber-32:
	cd lib/w32xx && $(MAKE) clobber
libw32xx-clobber-64:
	cd lib/w32xx && $(MAKE) clobber WIN64=1
libw3270stubs-clobber: libw3270stubs-clobber-32 libw3270stubs-clobber-64
libw3270stubs-clobber-32:
	cd lib/w3270stubs && $(MAKE) clobber
libw3270stubs-clobber-64:
	cd lib/w3270stubs && $(MAKE) clobber WIN64=1
libexpat-clobber: libexpat-clobber-32 libexpat-clobber-64
libexpat-clobber-32:
	cd lib/libexpat && $(MAKE) clobber
libexpat-clobber-64:
	cd lib/libexpat && $(MAKE) clobber WIN64=1
x3270-clobber:
	cd x3270 && $(MAKE) clobber
c3270-clobber:
	cd c3270 && $(MAKE) clobber
s3270-clobber:
	cd s3270 && $(MAKE) clobber
b3270-clobber:
	cd b3270 && $(MAKE) clobber
tcl3270-clobber:
	cd tcl3270 && $(MAKE) clobber
pr3287-clobber:
	cd pr3287 && $(MAKE) clobber
x3270if-clobber:
	cd x3270if && $(MAKE) clobber
playback-clobber:
	cd playback && $(MAKE) clobber
wc3270-clobber: wc3270-clobber-32 wc3270-clobber-64
wc3270-clobber-32:
	cd wc3270 && $(MAKE) clobber
wc3270-clobber-64:
	cd wc3270 && $(MAKE) clobber WIN64=1
ws3270-clobber: ws3270-clobber-32 ws3270-clobber-64
ws3270-clobber-32:
	cd ws3270 && $(MAKE) clobber
ws3270-clobber-64:
	cd ws3270 && $(MAKE) clobber WIN64=1
wb3270-clobber: wb3270-clobber-32 wb3270-clobber-64
wb3270-clobber-32:
	cd wb3270 && $(MAKE) clobber
wb3270-clobber-64:
	cd wb3270 && $(MAKE) clobber WIN64=1
wpr3287-clobber: wpr3287-clobber-32 wpr3287-clobber-64
wpr3287-clobber-32:
	cd wpr3287 && $(MAKE) clobber
wpr3287-clobber-64:
	cd wpr3287 && $(MAKE) clobber WIN64=1
wx3270if-clobber: wx3270if-clobber-32 wx3270if-clobber-64
wx3270if-clobber-32:
	cd wx3270if && $(MAKE) clobber
wx3270if-clobber-64:
	cd wx3270if && $(MAKE) clobber WIN64=1
wplayback-clobber: wplayback-clobber-32 wplayback-clobber-64
wplayback-clobber-32:
	cd wplayback && $(MAKE) clobber
wplayback-clobber-64:
	cd wplayback && $(MAKE) clobber WIN64=1

windows-lib-test: libw3270-test libw32xx-test
libw3270-test: libw3270-test-32 libw3270-test-64
libw3270-test-32: libw3270-32
	cd lib/w3270 && $(MAKE) -f Makefile.test
libw3270-test-64: libw3270-64
	cd lib/w3270 && $(MAKE) -f Makefile.test WIN64=1
libw32xx-test: libw32xx-test-32 libw32xx-test-64
libw32xx-test-32: libw32xx-32
	cd lib/w32xx && $(MAKE) -f Makefile.test
libw32xx-test-64: libw32xx-64
	cd lib/w32xx && $(MAKE) -f Makefile.test WIN64=1

ifdef UNIX
unix-lib-test:
	cd lib/3270 && $(MAKE) -f Makefile.test
	cd lib/32xx && $(MAKE) -f Makefile.test

ALLPYTESTS := $(shell for i in  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if; do [ -f $$i/Test/testSmoke.py ] && printf " %s" "$$i/Test/test*.py"; done)
PYTESTS=$(ALLPYTESTS)
PYSMOKETESTS := $(shell for i in  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if; do [ -f $$i/Test/testSmoke.py ] && printf " %s" "$$i/Test/testSmoke.py"; done)
TESTPATH := $(shell for i in  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if; do printf "%s" "obj/x86_64-pc-linux-gnu/$$i/:"; done)

RUNTESTS=PATH="$(TESTPATH)$$PATH" python3 -m unittest $(TESTOPTIONS)

b3270-test: b3270
	$(RUNTESTS) b3270/Test/test*.py

c3270-test: c3270
	$(RUNTESTS) c3270/Test/test*.py

pr3287-test: pr3287
	$(RUNTESTS) pr3287/Test/test*.py

s3270-test: s3270
	$(RUNTESTS) s3270/Test/test*.py

tcl3270-test: tcl3270 s3270
	$(RUNTESTS) tcl3270/Test/test*.py

x3270-test: x3270
	$(RUNTESTS) x3270/Test/test*.py

x3270if-test: x3270if
	$(RUNTESTS) x3270if/Test/test*.py

pytests:  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if
	$(RUNTESTS) $(PYTESTS)
test:  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if unix-lib-test pytests
smoketest:  x3270 c3270 s3270 b3270 tcl3270 pr3287 x3270if
	$(RUNTESTS) $(PYSMOKETESTS)
endif
