#!/bin/bash
# Get an updated config.sub and config.guess
if [[ ${target_platform} != win-* ]]; then
  cp $BUILD_PREFIX/share/gnuconfig/config.* ./vendor/oniguruma
  cp $BUILD_PREFIX/share/gnuconfig/config.* ./config
fi

set -ex

chmod +x configure

./configure --prefix=$PREFIX --with-oniguruma=$PREFIX

if [[ ${target_platform} != win-* ]]; then
  patch_libtool
fi

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check
fi

make install
