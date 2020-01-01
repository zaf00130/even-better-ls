#!/bin/bash

COREUTILS_VER=8.31

#
# Copy over the colors generator
chmod 755 ls_colors_generator.py
sudo cp ls_colors_generator.py /usr/local/bin/ls_colors_generator

#
# Download, compile and install custom executables
if  [[ $1 != "--script-only" ]]; then
  #
  # Cleanup
  [ -d "coreutils-${COREUTILS_VER}" ] && \
    rm -rf coreutils-${COREUTILS_VER}

  #
  # Download coreutils and patch
  [ ! -f "coreutils-${COREUTILS_VER}.tar.xz" ]  && \
    wget https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VER}.tar.xz

  tar -xf coreutils-${COREUTILS_VER}.tar.xz
  cd coreutils-${COREUTILS_VER}
  patch -p0 < ../ls.patch

  #
  # Compile and copy binaries
  ./configure
  make
  for bin in ls dir vdir; do
    echo "Copying ${bin} to /usr/local/bin/${bin}-i"
    sudo cp src/${bin} /usr/local/bin/${bin}-i
  done
fi
