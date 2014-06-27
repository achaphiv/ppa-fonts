#!/bin/bash

set -ex

PACKAGE='openjdk-7'
PATCH_NAME='fontfix.patch'
PPA_VERSION='ppa1'

STARTING_DIR=$(pwd)

function build {
	DIST=$1
	VERSION=$2

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -r ${BUILD_DIR} || true
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	cd ${PACKAGE}*/

	cp ${STARTING_DIR}/${PATCH_NAME} debian/patches/

	patch -p1 < ${STARTING_DIR}/add_fontfix_patch.patch

	CHANGELOG=$(mktemp)

	cat <<-EOF > ${CHANGELOG}
	${PACKAGE} (${VERSION}${PPA_VERSION}) ${DIST}; urgency=low

	  * Add fontfix patch
	  * Use fontfix patch

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
build trusty 7u55-2.4.7-1ubuntu1
