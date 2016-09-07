#!/bin/bash

set -ex

STARTING_DIR=$(pwd)

function build_freetype {
	PACKAGE='freetype'
	DIST=$1
	VERSION=$2
	PATCH_NAME=$3
	PPA_VERSION=$4

	NEW_VERSION=2.6.5-0ubuntu0${PPA_VERSION}

	BUILD_DIR=build-${PACKAGE}-${DIST}
	rm -rf ${BUILD_DIR}
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}

	apt-get source ${PACKAGE}=${VERSION}

	# Remove old packages
	rm *.orig.tar.gz
	rm *.diff.gz
	rm *.dsc

	mv ${PACKAGE}* ${PACKAGE}-2.6.5/
	cd ${PACKAGE}*/

	# ignore compiler warnings
	sed -i -e '/export DEB_CFLAGS_MAINT_APPEND := -Werror/d' debian/rules

	cp ${STARTING_DIR}/${PACKAGE}/${PATCH_NAME} debian/patches-freetype/
	echo ${PATCH_NAME} >> debian/patches-freetype/series

	# remove since 2.6.5 changes things
	sed -i -e '/0001-Revert-pcf-Signedness-fixes.patch/d' debian/patches-freetype/series
	sed -i -e '/compiler_hardening_fixes.patch/d' debian/patches-ft2demos/series

	# Level | Failure
	# 0     | impossible (all checks disabled)
	# 1     | symbols have disappeared
	# 2     | symbols have been introduced
	# 3     | libraries have disappeared
	# 4     | libraries have been introduced
	sed -i -e 's/DPKG_GENSYMBOLS_CHECK_LEVEL = 4/DPKG_GENSYMBOLS_CHECK_LEVEL = 0/' debian/rules

	CHANGELOG=$(mktemp)

	cat <<-EOF > ${CHANGELOG}
	${PACKAGE} (${NEW_VERSION}) ${DIST}; urgency=low

	  * Ignore compiler warnings
	  * Update freetype to 2.6.5
	  * Ignore extra symbols

	 -- ${DEBFULLNAME} <${DEBEMAIL}>  $(date -R)

	EOF

	cat debian/changelog >> ${CHANGELOG}

	mv ${CHANGELOG} debian/changelog

	rm *.tar.bz2
  gpg --recv-keys E707FDA5
	./debian/rules get-orig-source
	mv *.orig.tar.gz ..
	tar xvzfp ../*.orig.tar.gz --strip-components=1

	debuild -S -sd

	cd ../

	dput -c ${STARTING_DIR}/dput.cf ppa *changes

	cd ${STARTING_DIR}
}

#build_freetype trusty 2.5.2-1ubuntu2.5 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype utopic 2.5.2-2ubuntu1.1 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype vivid 2.5.2-2ubuntu3.1 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
#build_freetype wily 2.5.2-4ubuntu2 'infinality-2.5.3.patch' 'ppa1bohoomileb5a6af0e99ec0d1c25521b6f8196106508c9360'
build_freetype xenial 2.6.1-0.1ubuntu2 'enable-subpixel-hinting.patch' 'ppa4'
#build_fontconfig xenial 2.11.94-0ubuntu1 ppa1
