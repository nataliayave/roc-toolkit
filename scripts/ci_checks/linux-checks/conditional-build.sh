#!/usr/bin/env bash

set -euxo pipefail

# optional dependencies: none, optional targets: none
scons -Q --enable-werror --build-3rdparty=all \
      --disable-shared \
      --disable-tools \
      --disable-c11 \
      --disable-libunwind \
      --disable-openfec \
      --disable-speex \
      --disable-sox \
      --disable-pulseaudio

# optional dependencies: none, optional targets: all
scons -Q --enable-werror --build-3rdparty=all \
      --enable-static \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      --disable-libunwind \
      --disable-openfec \
      --disable-speex \
      --disable-sox \
      --disable-pulseaudio \
      test

# optional dependencies: all, optional targets: all
scons -Q --enable-werror --build-3rdparty=all \
      --enable-static \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      test
