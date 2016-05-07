#!/bin/bash

set -ex

STARTING_DIR=$(pwd)

function build_freetype {
	PACKAGE='freetype'
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
	cp ${STARTING_DIR}/${PACKAGE}/${PATCH_NAME} debian/patches-freetype/
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

function build_fontconfig {
	PACKAGE='fontconfig'
	DIST=$1
	VERSION=$2
	PPA_VERSION=$3

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	cd ${PACKAGE}*/

	cp -r ${STARTING_DIR}/fontconfig-ultimate/conf.d.infinality .
	EDITOR=/bin/true dpkg-source -q --commit . bohoomil.patch

	cp -r ${STARTING_DIR}/fontconfig-ultimate/fontconfig_patches_git debian/patches/

	# Patch stuff
	sed -i -e '/00_old_diff_gz.patch/d' debian/patches/series
	sed -i -e '/06_ubuntu_lcddefault.patch/d' debian/patches/series
	sed -i -e '/07_no_bitmaps.patch/d' debian/patches/series
	echo "fontconfig_patches_git/01-configure.patch" >> debian/patches/series
	echo "fontconfig_patches_git/02-configure.ac.patch" >> debian/patches/series
	echo "fontconfig_patches_git/03-Makefile.in.patch" >> debian/patches/series
	echo "fontconfig_patches_git/05-Makefile.am.in.patch" >> debian/patches/series

	CHANGELOG=$(mktemp)

	cat <<-EOF > ${CHANGELOG}
	${PACKAGE} (${VERSION}${PPA_VERSION}) ${DIST}; urgency=low

	  * Use bohoomil\'s patches

	 -- ${DEBFULLNAME} <${DEBEMAIL}>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	cd ${STARTING_DIR}
}

#build_freetype trusty 2.5.2-1ubuntu2.5 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype utopic 2.5.2-2ubuntu1.1 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype vivid 2.5.2-2ubuntu3.1 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype wily 2.5.2-4ubuntu2 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype xenial 2.6.1-0.1ubuntu2 '03-infinality-2.6.1-2015.11.08.patch' 'ppa1bohoomil20151108'
#build_fontconfig xenial 2.11.94-0ubuntu1 ppa1
