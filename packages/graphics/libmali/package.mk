# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="libmali"
PKG_VERSION="a8f01d313efe75e77955d757c4fbdaf8e73598ed"
PKG_SHA256="a3325215b9ca7584efa722f8087a6a2dbf953514504ae2c4d7dff2203ad3ca3e"
PKG_ARCH="arm aarch64"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/LibreELEC/libmali"
PKG_URL="https://github.com/LibreELEC/libmali/archive/$PKG_VERSION.tar.gz"
PKG_LONGDESC="OpenGL ES user-space binary for the ARM Mali GPU family"
PKG_STAMP="$MALI_FAMILY"

PKG_DEPENDS_TARGET="libdrm"

if [ "$MALI_FAMILY" = "t620" -o "$MALI_FAMILY" = "t720" ]; then
  PKG_DEPENDS_TARGET+=" wayland"
fi

PKG_CMAKE_OPTS_TARGET="-DMALI_VARIANT=$MALI_FAMILY"

if [ "$TARGET_ARCH" = "aarch64" ]; then
  PKG_CMAKE_OPTS_TARGET+=" -DMALI_ARCH=aarch64-linux-gnu"
fi

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp -v $PKG_DIR/scripts/libmali-config $INSTALL/usr/bin

  if [ $(ls -1q $INSTALL/usr/lib/libmali-*.so | wc -l) -gt 1 ]; then
    ln -sfv /var/lib/libmali/libmali.so $INSTALL/usr/lib/libmali.so
  fi
}

post_install() {
  enable_service libmali-config.service
}
