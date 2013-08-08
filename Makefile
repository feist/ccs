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
	install -d ${DESTDIR}/usr/share/ccs/
	install cluster.rng.in ${DESTDIR}/usr/share/ccs/cluster.rng
	install empty_cluster.conf ${DESTDIR}/usr/share/ccs/cluster.rng
	install -d ${DESTDIR}/${MANDIR}/man8
	install ccs.8 -m644 ${DESTDIR}/${MANDIR}/man8

test:
	cd unit_tests; ./unittest.pl
