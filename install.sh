#!/bin/bash

COREUTILS_VER=8.31

#
# Copy over the colors generator
chmod 755 ls_colors_generator.py
sudo cp ls_colors_generator.py /usr/bin/ls_colors_generator

#
# Cleanup
[ -d "coreutils-${COREUTILS_VER}" ] && \
    rm -rf coreutils-${COREUTILS_VER}
[ -f "coreutils-${COREUTILS_VER}.tar.xz" ]  && \
    rm -f coreutils-${COREUTILS_VER}.tar.xz

#
# Download coreutils and patch
wget https://ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VER}.tar.xz
tar -xf coreutils-${COREUTILS_VER}.tar.xz
rm coreutils-${COREUTILS_VER}.tar.xz
cd coreutils-${COREUTILS_VER}
patch -p0 < ../ls.patch

#
# Compile and copy binaries
./configure
make
for bin in ls dir vdir; do
    echo "Copying ${bin} to /usr/bin/${bin}-i"
    sudo cp src/${bin} /usr/bin/${bin}-i
done

