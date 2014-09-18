#!/bin/bash

set -ex

PACKAGE='openjdk-7'

STARTING_DIR=$(pwd)

function build {
	DIST=$1
	VERSION=$2
	PPA_VERSION=$3

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -r ${BUILD_DIR} || true
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	cd ${PACKAGE}*/

	patch -p1 < ${STARTING_DIR}/enable_infinality.patch

	CHANGELOG=$(mktemp)

	cat <<-EOF > ${CHANGELOG}
	${PACKAGE} (${VERSION}${PPA_VERSION}) ${DIST}; urgency=low

	  * Turn on --enable-infinality flag

	 -- ${DEBFULLNAME} <${DEBEMAIL}>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	debuild -S -sd

	cd ../

	dput -c ${STARTING_DIR}/dput.cf openjdk-fontfix *changes

	cd ${STARTING_DIR}
}


#build precise 7u51-2.4.4-0ubuntu0.12.04.2
#build saucy 7u51-2.4.4-0ubuntu0.13.10.1
build trusty 7u65-2.5.2-3~14.04 ppa1
#build trusty 7u65-2.5.1-4ubuntu1~0.14.04.2 ppa1
