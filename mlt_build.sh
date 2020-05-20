#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd mlt

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

#export CC=/home/wangjh/work/video_edit/ffmpeg-android-wjhtinger2/toolchain-android/bin/arm-linux-androideabi-gcc
#export CXX=/home/wangjh/work/video_edit/ffmpeg-android-wjhtinger2/toolchain-android/bin/arm-linux-androideabi-g++

make clean

echo "################################################"
./configure \
--target-arch="$NDK_ABI" \
--target-os="Linux" \
--sysroot="$NDK_SYSROOT" \
--prefix="${2}/build/${1}" \
--disable-mmx \
--disable-sse \
--disable-sse2 \
--disable-sdl \
--disable-sdl2 \
--disable-qt \
--disable-decklink \
--disable-plus \
--disable-rtaudio \
 || exit 1

echo "################################################22"

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
