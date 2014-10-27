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


build utopic 7u71-2.5.3-0ubuntu1 ppa1
