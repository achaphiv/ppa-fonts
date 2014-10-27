#!/bin/bash

set -ex

PACKAGE='freetype'

STARTING_DIR=$(pwd)

function build {
	DIST=$1
	VERSION=$2
	PATCH_NAME=$3
	PPA_VERSION=$4

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

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
	  * Disable redundant subpixel patch
	  * Use infinality patch
	  * Ignore extra symbols

	 -- ${DEBFULLNAME} <${DEBEMAIL}>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	debuild -S -sd

	cd ../

	dput -c ${STARTING_DIR}/dput.cf ppa *changes

	cd ${STARTING_DIR}
}

#build saucy 2.4.12-0ubuntu1.1 'freetype-entire-infinality-patchset-20130514-01.patch' 'ppa3infinality20130515'
#build trusty 2.5.2-1ubuntu2.2 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
build utopic 2.5.2-2ubuntu1 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
