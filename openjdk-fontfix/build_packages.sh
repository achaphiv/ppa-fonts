#!/bin/bash

set -ex

STARTING_DIR=$(pwd)

function build {
	PACKAGE=$1
	DIST=$2
	VERSION=$3
	PPA_VERSION=$4
	PATCH=$5

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	cd ${PACKAGE}*/

	cp ${STARTING_DIR}/add-fontconfig-support.diff debian/patches/

	patch -p1 < ${STARTING_DIR}/${PATCH}

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

build openjdk-7 precise 7u91-2.6.3-0ubuntu0.12.04.1 ppa1 enable_infinality.patch
#build openjdk-7 trusty 7u91-2.6.3-0ubuntu0.14.04.1 ppa1 enable_infinality.patch
#build openjdk-8 trusty 8u45-b14-1~14.04 ppa1 enable_tuxjdk.patch
#build openjdk-7 utopic 7u79-2.5.5-0ubuntu0.14.10.2 ppa1 enable_infinality.patch
#build openjdk-8 utopic 8u40~b09-1 ppa2 enable_tuxjdk.patch
#build openjdk-7 vivid 7u91-2.6.3-0ubuntu0.15.04.1 ppa1 enable_infinality.patch
#build openjdk-8 vivid 8u45-b14-1 ppa1 enable_tuxjdk.patch
#build openjdk-7 wily 7u91-2.6.3-0ubuntu0.15.10.1 ppa1 enable_infinality.patch
#build openjdk-8 wily 8u66-b17-1 ppa1 enable_tuxjdk.patch

