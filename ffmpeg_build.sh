#!/bin/bash

. abi_settings.sh $1 $2 $3

pushd ffmpeg

case $1 in
  armeabi-v7a | armeabi-v7a-neon)
    CPU='cortex-a8'
  ;;
  x86)
    CPU='i686'
  ;;
esac

make clean

#export PKG_CONFIG_PATH=${TOOLCHAIN_PREFIX}/lib/pkgconfig
export TARGET_OS=android
#export NDK_ABI=armv7-a
#export CPU=armv7-a

./configure \
--target-os="$TARGET_OS" \
--cross-prefix="$CROSS_PREFIX" \
--arch="$NDK_ABI" \
--cpu="$CPU" \
--enable-runtime-cpudetect \
--sysroot="$NDK_SYSROOT" \
--enable-asm \
--enable-neon \
--enable-cross-compile \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-decoder=hevc_mediacodec \
--enable-decoder=vp8_mediacodec \
--enable-decoder=vp9_mediacodec \
--enable-decoder=mpeg4_mediacodec \
--enable-hwaccel=h264_mediacodec \
--disable-swscale \
--enable-pic \
--enable-libx264 \
--enable-libass \
--enable-libfreetype \
--enable-libfribidi \
--disable-libmp3lame \
--disable-fontconfig \
--disable-libv4l2 \
--enable-pthreads \
--disable-debug \
--enable-version3 \
--enable-hardcoded-tables \
--disable-ffplay \
--disable-ffprobe \
--enable-gpl \
--enable-yasm \
--disable-doc \
--disable-shared \
--enable-static \
--pkg-config="${2}/ffmpeg-pkg-config" \
--prefix="${TOOLCHAIN_PREFIX}" \
--extra-cflags="-I${TOOLCHAIN_PREFIX}/include $CFLAGS -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD" \
--extra-ldflags="-L${TOOLCHAIN_PREFIX}/lib $LDFLAGS" \
--extra-libs="-lpng -lexpat -lm" \
--extra-cxxflags="$CXX_FLAGS" || exit 1

make -j${NUMBER_OF_CORES} && make install || exit 1

popd
