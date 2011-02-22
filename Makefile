#
# Copyright (C) 2010 Trond Norbye
# Copyright (C) 2010 Membase, Inc.
# All rights reserved.
#
# Use and distribution licensed under the BSD license.  See
# the COPYING file in this directory for full text.
#
# Dependencies:
#
#   libevent, version >= 2.0.7-rc
#   libcurl, version >= 7.21.1-w64_patched
#   erlang, version >= 5.7.4
#
# To use this Makefile, see the repo manifest:
#   https://github.com/membase/manifest
#
# That will build many sibling directories to ns_server.
#
# To run:
#
#   ./ns_server/start_shell.sh
#

BUILDPREFIX=/tmp/membase-build
DISTPREFIX=/tmp/membase-dist
DISTFILE=membase-dev.tar.gz

# --------------------------------------------------------------

all: $(BUILDPREFIX) \
     $(BUILDPREFIX)/bin \
     $(BUILDPREFIX)/lib \
     $(BUILDPREFIX)/bin/memcached${EXE} \
     $(BUILDPREFIX)/include/libconflate \
     $(BUILDPREFIX)/include/libmemcached \
     $(BUILDPREFIX)/include/libvbucket \
     $(BUILDPREFIX)/bin/membase \
     $(BUILDPREFIX)/bin/memcachetest${EXE} \
     $(BUILDPREFIX)/bin/moxi${EXE} \
     $(BUILDPREFIX)/bin/vbucketmigrator${EXE} \
     $(BUILDPREFIX)/lib/bucket_engine.so \
     $(BUILDPREFIX)/lib/ep.so \
     $(BUILDPREFIX)/lib/ns_server/ebin
	@echo "Everything successfully built"

dist: all
	rm -rf $(DISTPREFIX)
	cp -pr $(BUILDPREFIX) $(DISTPREFIX)
	rm -rf $(DISTPREFIX)/lib/*.la \
               $(DISTPREFIX)/lib/*.a \
               $(DISTPREFIX)/include \
               $(DISTPREFIX)/share \
               $(DISTPREFIX)/bin/engine_testapp* \
               $(DISTPREFIX)/lib/basic_engine_testsuite* \
               $(DISTPREFIX)/lib/example_protocol* \
               $(DISTPREFIX)/lib/libconflate* \
               $(DISTPREFIX)/lib/libmemcached* \
               $(DISTPREFIX)/lib/libvbucket* \
               $(DISTPREFIX)/lib/pkgconfig \
               $(DISTPREFIX)/lib/bucket_engine.*.so \
               $(DISTPREFIX)/lib/ep.*.so \
               $(DISTPREFIX)/lib/ep_testsuite* \
               $(DISTPREFIX)/lib/libhashkit* \
               $(DISTPREFIX)/lib/timing_tests.*.so
	(cd $(DISTPREFIX); tar cf - bin lib var) | gzip -9 > $(DISTFILE)
	rm -rf $(DISTPREFIX)

test: test-shallow

clean: clean-shallow

# --------------------------------------------------------------

LIBRARY_OPTIONS=--disable-static --enable-shared
CONFIGURE_FLAGS=
BUCKET_ENGINE_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
EP_ENGINE_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
LIBCONFLATE_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
LIBMEMCACHED_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
LIBVBUCKET_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
MEMCACHED_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
MEMCACHETEST_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
MOXI_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)
VBUCKETMIGRATOR_CONFIGURE_FLAGS=$(CONFIGURE_FLAGS)

win32:
	$(MAKE) EXE=.exe BUILDPREFIX=$(BUILDPREFIX)32 \
                LIBRARY_OPTIONS="--enable-static --disable-shared"

win64:
	$(MAKE) EXE=.exe BUILDPREFIX=$(BUILDPREFIX)64 \
                         CC="x86_64-w64-mingw32-gcc -std=gnu99" \
                         CXX=x86_64-w64-mingw32-g++ \
                         CONFIGURE_FLAGS="--host=x86_64-w64-mingw32 \
                                          --build=i686-pc-mingw32" \
                         LIBRARY_OPTIONS="--enable-static --disable-shared" \
                         MARCH=


solaris:
	$(MAKE) BUILDPREFIX=$(BUILDPREFIX)64 \
            CONFIGURE_FLAGS="--with-debug" \
            EP_ENGINE_CONFIGURE_FLAGS="--with-debug \
                                       --enable-system-libsqlite3 \
                                       CPPFLAGS=-I/opt/boost/cc/include" \
            MEMCACHED_CONFIGURE_FLAGS=--enable-64bit \
            BUCKET_ENGINE_CONFIGURE_FLAGS="CFLAGS=-m64 LDFLAGS=-m64"

# --------------------------------------------------------------

test-shallow: all
	@(echo ---- bucket_engine; cd bucket_engine; $(MAKE) test)
	@(echo ---- ep-engine; cd ep-engine; $(MAKE) test)
	@(echo ---- libvbucket; cd libvbucket; $(MAKE) test)
	@(echo ---- ns_server; cd ns_server; $(MAKE) test)
	@(echo ---- vbucketmigrator; cd vbucketmigrator; $(MAKE) test)

test-deep: test-shallow
	@(echo ---- moxi; cd moxi; $(MAKE) test)

test-MISSING:
	@(echo ---- membase-cli; cd membase-cli; $(MAKE) test)
	@(echo ---- memcachetest; cd memcachetest; $(MAKE) test)

test-FAILING:
	@(echo ---- libconflate; cd libconflate; $(MAKE) test)
	@(echo ---- memcached; cd memcached; $(MAKE) test)

CLEANFILES=bucket_engine \
           ep-engine \
           libconflate \
           libmemcached \
           libvbucket \
           membase-cli \
           memcached \
           memcachetest \
           moxi \
           vbucketmigrator \
           $(BUILDPREFIX) $(DISTPREFIX) $(DISTFILE) \
           grommix

clean-deep:
	rm -rf $(CLEANFILES) *.stamp
	(cd ns_server && $(MAKE) clean)

clean-shallow:
	@if test -n "${EXE}"; then \
           (cd bucket_engine && $(MAKE) -f win32/Makefile.mingw clean) || true; \
           (cd ep-engine && $(MAKE) -f win32/Makefile.mingw clean) || true; \
           (cd memcached && $(MAKE) -f win32/Makefile.mingw clean) || true; \
        fi
	$(MAKE) COMPONENT_DO="$(MAKE) distclean || $(MAKE) clean || true" component_do
	rm -rf *.stamp

%.stamp: %.stamp_test
	-@echo $@

%.stamp_test:
	$(MAKE) COMPONENT=$* $@

$(BUILDPREFIX) $(BUILDPREFIX)/lib $(BUILDPREFIX)/bin:
	-@mkdir $@

# --------------------------------------------------------------

COMPONENT=unknown
COMPONENT_GIT=$(COMPONENT)
COMPONENT_GIT_CHECKOUT=master
COMPONENT_GERRIT=$(COMPONENT)
COMPONENT_AUTOGEN=./config/autorun.sh

$(COMPONENT)/configure: $(COMPONENT)/configure.ac
	(cd $(COMPONENT) && $(COMPONENT_AUTOGEN))

$(COMPONENT)/Makefile: $(COMPONENT)/configure
	@if test -n "${EXE}" && test -f $(COMPONENT)/win32/Makefile.mingw; then \
           touch $(COMPONENT)/Makefile; \
        else \
           (cd $(COMPONENT) && ./configure --prefix=$(BUILDPREFIX) \
                                           --enable-dependency-tracking \
                                           $(COMPONENT_CONFIGURE_FLAGS)); \
        fi

$(COMPONENT)/$(COMPONENT_OUT): $(COMPONENT)/Makefile $(COMPONENT).stamp
	@if test -n "${EXE}" && test -f $(COMPONENT)/win32/Makefile.mingw; then \
           (cd $(COMPONENT) && \
            $(MAKE) -f win32/Makefile.mingw LOCAL=$(BUILDPREFIX) all); \
            touch $(COMPONENT)/$(COMPONENT_OUT); \
        else \
           (cd $(COMPONENT) && $(MAKE) all); \
        fi

$(COMPONENT).stamp_test:
	@if test -d $(COMPONENT)/.git; then \
        if test -f $(COMPONENT).stamp; then \
                if ! (cd $(COMPONENT) && (git describe | diff ../$(COMPONENT).stamp -)); then \
                   (cd $(COMPONENT) && (git describe > ../$(COMPONENT).stamp)); \
                   fi; \
           else \
                (cd $(COMPONENT) && (git describe > ../$(COMPONENT).stamp)); \
           fi; \
        fi

component_do:
	@(echo ---- bucket_engine; cd bucket_engine; $(COMPONENT_DO))
	@(echo ---- ep-engine; cd ep-engine; $(COMPONENT_DO))
	@(echo ---- libconflate; cd libconflate; $(COMPONENT_DO))
	@(echo ---- libvbucket; cd libvbucket; $(COMPONENT_DO))
	@(echo ---- membase-cli; cd membase-cli; $(COMPONENT_DO))
	@(echo ---- memcached; cd memcached; $(COMPONENT_DO))
	@(echo ---- memcachetest; cd memcachetest; $(COMPONENT_DO))
	@(echo ---- moxi; cd moxi; $(COMPONENT_DO))
	@(echo ---- ns_server; cd ns_server; $(COMPONENT_DO))
	@(echo ---- vbucketmigrator; cd vbucketmigrator; $(COMPONENT_DO))

# --------------------------------------------------------------

LIBMEMCACHED=libmemcached-0.41_trond-norbye_mingw32-revno895

libmemcached/configure.ac:
	@if test -f grommit/$(LIBMEMCACHED).tar.gz; then \
           rm -rf libmemcached; \
           tar xzf grommit/$(LIBMEMCACHED).tar.gz; \
           mv $(LIBMEMCACHED) libmemcached; \
        else \
           bzr branch lp:libmemcached libmemcached; \
        fi

libmemcached/configure: libmemcached/configure.ac
	(cd libmemcached && ./config/autorun.sh)

libmemcached/Makefile: libmemcached/configure $(BUILDPREFIX)/bin/memcached${EXE}
	(cd libmemcached && ./configure --prefix=$(BUILDPREFIX) \
                                    --enable-dependency-tracking \
                                    $(LIBRARY_OPTIONS) \
                                    --disable-dtrace \
                                    --without-docs \
                                    --with-debug \
                                    --with-memcached=$(BUILDPREFIX)/bin/memcached${EXE} \
                                    $(LIBMEMCACHED_CONFIGURE_FLAGS))

libmemcached/libmemcached/libmemcached.la: libmemcached/Makefile
	(cd libmemcached && $(MAKE) all)

# --------------------------------------------------------------

$(BUILDPREFIX)/lib/bucket_engine.so: bucket_engine.stamp \
                                     $(BUILDPREFIX)/bin/memcached${EXE}
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=bucket_engine \
         COMPONENT_OUT=bucket_engine.la \
         COMPONENT_CONFIGURE_FLAGS="--with-memcached=../memcached \
                                    $(BUCKET_ENGINE_CONFIGURE_FLAGS)" \
         bucket_engine/bucket_engine.la
	@if test -n "${EXE}"; then \
           cp bucket_engine/.libs/bucket_engine.so $(BUILDPREFIX)/lib; \
           cp bucket_engine/.libs/bucket_engine.so $(BUILDPREFIX)/lib/bucket_engine.so.0; \
           cp bucket_engine/.libs/bucket_engine.so $(BUILDPREFIX)/lib/bucket_engine.so.0.0.0; \
        else \
            (cd bucket_engine && $(MAKE) install); \
        fi

$(BUILDPREFIX)/lib/ep.so: ep-engine.stamp \
                          $(BUILDPREFIX)/bin/memcached${EXE}
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=ep-engine \
         COMPONENT_OUT=ep.la \
         COMPONENT_CONFIGURE_FLAGS="--with-memcached=../memcached \
                                    --with-debug \
                                    $(EP_ENGINE_CONFIGURE_FLAGS)" \
         COMPONENT_GERRIT=membase \
         ep-engine/ep.la
	@if test -n "${EXE}"; then \
           cp ep-engine/.libs/ep.so $(BUILDPREFIX)/lib; \
           cp ep-engine/.libs/ep.so $(BUILDPREFIX)/lib/ep.so.0; \
           cp ep-engine/.libs/ep.so $(BUILDPREFIX)/lib/ep.so.0.0.0; \
        else \
           (cd ep-engine && $(MAKE) install); \
        fi

$(BUILDPREFIX)/include/libconflate: libconflate.stamp
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=libconflate \
         COMPONENT_OUT=libconflate.la \
         COMPONENT_CONFIGURE_FLAGS="$(LIBRARY_OPTIONS) \
                                    --without-check \
                                    --with-debug \
                                    $(LIBCONFLATE_CONFIGURE_FLAGS)" \
         libconflate/libconflate.la
	(cd libconflate && $(MAKE) install)

$(BUILDPREFIX)/include/libmemcached: libmemcached/libmemcached/libmemcached.la
	(cd libmemcached && $(MAKE) install)

$(BUILDPREFIX)/include/libvbucket: libvbucket.stamp \
                                   $(BUILDPREFIX)/include/libmemcached
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=libvbucket \
         COMPONENT_OUT=libvbucket.la \
         COMPONENT_CONFIGURE_FLAGS="$(LIBRARY_OPTIONS) \
                                    --without-check \
                                    --without-docs \
                                    --with-debug \
                                    $(LIBVBUCKET_CONFIGURE_FLAGS)" \
         libvbucket/libvbucket.la
	(cd libvbucket && $(MAKE) install)

$(BUILDPREFIX)/bin/membase: membase-cli.stamp
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=membase-cli \
         membase-cli/Makefile
	rm -f $(BUILDPREFIX)/bin/membase
	(cd membase-cli && $(MAKE) install)

$(BUILDPREFIX)/bin/memcached$(EXE): memcached.stamp
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=memcached \
         COMPONENT_OUT=memcached$(EXE) \
         COMPONENT_GIT_CHECKOUT=engine \
         COMPONENT_CONFIGURE_FLAGS="--enable-isasl \
                                    $(MEMCACHED_CONFIGURE_FLAGS)" \
         memcached/memcached$(EXE)
	@if test -n "${EXE}"; then \
           cp memcached/memcached$(EXE) $(BUILDPREFIX)/bin; \
        else \
           (cd memcached && $(MAKE) install); \
        fi

$(BUILDPREFIX)/bin/memcachetest$(EXE): memcachetest.stamp
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=memcachetest \
         COMPONENT_OUT=memcachetest${EXE} \
         COMPONENT_CONFIGURE_FLAGS="--with-memcached=$(BUILDPREFIX)/bin/memcached$(EXE) $(MEMCACHETEST_CONFIGURE_FLAGS)" \
         memcachetest/memcachetest$(EXE)
	(cd memcachetest && $(MAKE) install)

$(BUILDPREFIX)/bin/moxi${EXE}: moxi.stamp \
                               $(BUILDPREFIX)/include/libvbucket \
                               $(BUILDPREFIX)/include/libmemcached \
                               $(BUILDPREFIX)/include/libconflate
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=moxi \
         COMPONENT_OUT=moxi${EXE} \
         COMPONENT_CONFIGURE_FLAGS="--enable-moxi-libvbucket \
                                    --enable-moxi-libmemcached \
                                    --without-check \
                                    --with-memcached=$(BUILDPREFIX)/bin/memcached$(EXE) \
                                    $(MOXI_CONFIGURE_FLAGS)" \
         moxi/moxi${EXE}
	(cd moxi && $(MAKE) install)

$(BUILDPREFIX)/lib/ns_server/ebin: ns_server.stamp
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=ns_server \
         dev-symlink
	(cd ns_server && $(MAKE))

$(BUILDPREFIX)/bin/vbucketmigrator${EXE}: vbucketmigrator.stamp \
                                          $(BUILDPREFIX)/bin/memcached${EXE}
	$(MAKE) EXE=$(EXE) BUILDPREFIX=$(BUILDPREFIX) GITBASE=$(GITBASE) \
         COMPONENT=vbucketmigrator \
         COMPONENT_OUT=vbucketmigrator${EXE} \
         COMPONENT_CONFIGURE_FLAGS="--without-docs \
                                    --without-sasl \
                                    --with-isasl \
                                    --with-debug \
                                    $(VBUCKETMIGRATOR_CONFIGURE_FLAGS)" \
         vbucketmigrator/vbucketmigrator$(EXE)
	(cd vbucketmigrator && $(MAKE) install)

# --------------------------------------------------------------

dev-symlink:
	mkdir -p ns_server/bin ns_server/lib/memcached
	ln -f -s ../../memcached/memcached ns_server/bin/memcached
	ln -f -s ../../../memcached/.libs/default_engine.so ns_server/lib/memcached/default_engine.so
	ln -f -s ../../../memcached/.libs/stdin_term_handler.so ns_server/lib/memcached/stdin_term_handler.so
	mkdir -p ns_server/bin/bucket_engine
	ln -f -s ../../../bucket_engine/.libs/bucket_engine.so ns_server/bin/bucket_engine/bucket_engine.so
	mkdir -p ns_server/bin/ep_engine
	ln -f -s ../../../ep-engine/.libs/ep.so ns_server/bin/ep_engine/ep.so
	mkdir -p ns_server/bin/moxi
	ln -f -s ../../../moxi/moxi ns_server/bin/moxi/moxi
	mkdir -p ns_server/bin/vbucketmigrator
	ln -f -s ../../../vbucketmigrator/vbucketmigrator ns_server/bin/vbucketmigrator/vbucketmigrator

install-symlink:
	ln -f -s ../../../bin/memcached $(BUILDPREFIX)/lib/ns_server/bin/memcached/memcached
	ln -f -s ../../../lib/default_engine.so $(BUILDPREFIX)/lib/ns_server/bin/memcached/default_engine.so
	ln -f -s ../../../lib/stdin_term_handler.so $(BUILDPREFIX)/lib/ns_server/bin/memcached/stdin_term_handler.so
	ln -f -s ../../../lib/bucket_engine.so $(BUILDPREFIX)/lib/ns_server/bin/bucket_engine/bucket_engine.so
	ln -f -s ../../../lib/ep.so $(BUILDPREFIX)/lib/ns_server/bin/ep_engine/ep.so
	ln -f -s ../../../bin/moxi $(BUILDPREFIX)/lib/ns_server/bin/moxi/moxi
	ln -f -s ../../../bin/vbucketmigrator $(BUILDPREFIX)/lib/ns_server/bin/vbucketmigrator/vbucketmigrator

