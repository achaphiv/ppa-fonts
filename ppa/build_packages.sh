#!/bin/sh

set -ex

PACKAGE='freetype'
PATCH_NAME='freetype-entire-infinality-patchset-20130514-01.patch'
PPA_VERSION='ppa3infinality20130515'

STARTING_DIR=$(pwd)

function build {
	DIST=$1
	VERSION=$2

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -r ${BUILD_DIR} || true
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	# Meh repo has own copy from old dist
	rm ${PACKAGE}*.orig.tar.gz
	wget https://launchpad.net/~no1wantdthisname/+archive/ppa/+files/freetype_2.4.12.orig.tar.gz

	cd ${PACKAGE}*/

	# ignore compiler warnings
	sed -i -e '/export DEB_CFLAGS_MAINT_APPEND := -Werror/d' debian/rules

	# remove since infinality already enables this
	sed -i -e '/enable-subpixel-rendering.patch/d' debian/patches-freetype/series

	# add/use infinality patch
	cp ${STARTING_DIR}/${PATCH_NAME} debian/patches-freetype/
	echo ${PATCH_NAME} >> debian/patches-freetype/series

	# Level | Failure
	# 0     | impossible (all checks disabled)
	# 1     | symbols have disappeared
	# 2     | symbols have been introduced
	# 3     | libraries have disappeared
	# 4     | libraries have been introduced
	sed -i -e 's/DPKG_GENSYMBOLS_CHECK_LEVEL = 4/DPKG_GENSYMBOLS_CHECK_LEVEL = 1/' debian/rules

	CHANGELOG=$(mktemp)

	cat <<-EOF > ${CHANGELOG}
	${PACKAGE} (${VERSION}${PPA_VERSION}) ${DIST}; urgency=low

	  * Ignore compiler warnings
	  * Add infinality patch
	  * Disable subpixel patch
	  * Use infinality patch
	  * Ignore extra symbols

	 -- Bob Chez <no1wantdthisname@gmail.com>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	debuild -S -sd

	cd ../

	dput -c ${STARTING_DIR}/dput.cf ppa *changes

	cd ${STARTING_DIR}
}

build saucy 2.4.12-0ubuntu1.1

