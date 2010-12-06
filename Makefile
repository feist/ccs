# Basic makefile for creating tarball or installing ccs
#

VERSION=0.1.0
SBINDIR=/usr/sbin/
DESTDIR=

tarball:
	mkdir -p ccs-${VERSION}
	cp Makefile ccs ccs-${VERSION}
	tar -czvf ccs-${VERSION}.tar.gz ccs-${VERSION}

install:
	install ccs ${DESTDIR}/${SBINDIR}/ccs

test:
	cd unit_tests; ./unittest.pl
