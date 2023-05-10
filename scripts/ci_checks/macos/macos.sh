#!/usr/bin/env bash

set -euxo pipefail

brew install \
     automake scons ragel gengetopt \
     libuv speexdsp sox openssl@3 \
     cpputest google-benchmark

# debug build with sanitizers
scons -Q \
      --enable-werror \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      --enable-debug \
      --sanitizers=all \
      --build-3rdparty=openfec \
      test

# normal release build
scons -Q \
      --enable-werror \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      --build-3rdparty=openfec \
      test

# + enable static lib
# + build all dependencies
scons -Q \
      --enable-werror \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      --enable-static \
      --build-3rdparty=all \
      test

# + set deployment target
# + enable universal binaries
scons -Q \
      --enable-werror \
      --enable-tests \
      --enable-benchmarks \
      --enable-examples \
      --enable-static \
      --build-3rdparty=all \
      --macos-platform=10.12 \
      --macos-arch=all \
      test
