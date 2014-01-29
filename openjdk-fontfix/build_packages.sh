#!/bin/bash

set -ex

PACKAGE='openjdk-7'
PATCH_NAME='fontfix.patch'
PPA_VERSION='ppa1'

function build {
	DIST=$1
	VERSION=$2

	STARTING_DIR=$(pwd)

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
	openjdk-7 (${VERSION}${PPA_VERSION}) ${DIST}; urgency=low

	  * Add fontfix patch
	  * Use fontfix patch

	 -- Bob Chez <no1wantdthisname@gmail.com>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	debuild -S -sd

	cd ../

	dput openjdk-fontfix *changes
}

build precise 7u51-2.4.4-0ubuntu0.12.04.2
build saucy 7u51-2.4.4-0ubuntu0.13.10.1

