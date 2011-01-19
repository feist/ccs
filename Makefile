# Basic makefile for creating tarball or installing ccs
#

VERSION=0.1.1
SBINDIR=/usr/sbin/
MANDIR=/usr/share/man/
DESTDIR=

tarball:
	mkdir -p ccs-${VERSION}
	cp Makefile ccs ccs-${VERSION}
	tar -czvf ccs-${VERSION}.tar.gz ccs-${VERSION}

install:
	install ccs ${DESTDIR}/${SBINDIR}/ccs
	install -d ${MANDIR}/man8
	install ccs.8 ${MANDIR}/man8

test:
	cd unit_tests; ./unittest.pl
