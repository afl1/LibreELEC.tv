# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="minigbm"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://chromium.googlesource.com/chromiumos/platform/minigbm"
#PKG_VERSION="5b39ef5f10ed702dea040b54324cfae1fc068310" # amlogic
#PKG_SHA256=""
PKG_VERSION="067594b15aa39835f49058853d3f1f586124c101" # google
PKG_SHA256="2c4342328849dccd7575415b9b8ddf088ed404b0320d6f411532c00ec632755a"
PKG_URL="https://github.com/chewitt/minigbm/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="minigbm-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain libdrm"
PKG_SECTION="graphics"
PKG_SHORTDESC="minigbm: A small library to support ARM mali blobs without GBM symbols"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"

make_target() {
  make ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_KERNEL_PREFIX \
       CFLAGS="$CFLAGS -O -DDRV_MESON=1" DRV_MESON=1 LIBDIR="$INSTALL/usr/lib"
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PR gbm.h $SYSROOT_PREFIX/usr/include/
    cp -PR gbm.pc $SYSROOT_PREFIX/usr/include/

  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR libminigbm.so.1.0.0 $SYSROOT_PREFIX/usr/lib
    ln -sf libminigbm.so.1.0.0 $SYSROOT_PREFIX/usr/lib/libgbm.so
    ln -sf libminigbm.so.1.0.0 $SYSROOT_PREFIX/usr/lib/libgbm.so.1

  mkdir -p $INSTALL/usr/lib
    cp -PR libminigbm.so.1.0.0 $INSTALL/usr/lib
    ln -sf libminigbm.so.1.0.0 $INSTALL/usr/lib/libgbm.so
    ln -sf libminigbm.so.1.0.0 $INSTALL/usr/lib/libgbm.so.1
}
