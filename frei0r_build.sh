#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd frei0r

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

#make clean

./autogen.sh

make clean

./configure \
--host="$NDK_TOOLCHAIN_ABI" \
--with-sysroot="$NDK_SYSROOT" \
--prefix="${TOOLCHAIN_PREFIX}" \
--enable-static \
--enable-shared \
 || exit 1


make -j${NUMBER_OF_CORES} && make install || exit 1

popd
