#!/bin/bash

dos2unix Source/**/*.cpp

patch -p1 < $RECIPE_DIR/patches/Use-system-libs.patch
patch -p1 < $RECIPE_DIR/patches/Fix-compatibility-with-system-libpng.patch
patch -p1 < $RECIPE_DIR/patches/CVE-2019-12211-13.patch

# remove all included libs to make sure these don't get used during compile
rm -r Source/Lib* Source/ZLib Source/OpenEXR
# clear files which cannot be built due to dependencies on private headers
# (see also unbundle patch)
> Source/FreeImage/PluginG3.cpp
> Source/FreeImageToolkit/JPEGTransform.cpp

sh $RECIPE_DIR/posix/posix_gensrclist.sh
if [ `uname` == Darwin ]; then
	cat -e -t -v Makefile.srcs
	sed -E 's/^ +//; s/ +$//; /^$/d' Makefile.srcs
fi
make -f Makefile.gnu dos2unix

sh $RECIPE_DIR/posix/posix_genfipsrclist.sh
if [ `uname` == Darwin ]; then
	cat -e -t -v Makefile.fip
	sed -E 's/^ +//; s/ +$//; /^$/d' Makefile.fip
fi
make -f Makefile.fip dos2unix

echo "MAKEFILE OSX\n\n"
cat Makefile.osx
echo "\n\nMAKEFILE GENERAL\n\n"
cat Makefile

make VERBOSE=1 -j${CPU_COUNT}
make install PREFIX="${PREFIX}" DESTDIR="${PREFIX}" INCDIR="${PREFIX}/include" INSTALLDIR="${PREFIX}/lib"