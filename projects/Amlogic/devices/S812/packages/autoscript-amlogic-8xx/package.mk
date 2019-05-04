# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="autoscript-amlogic-8xx"
PKG_VERSION="0.2"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml:host"
PKG_LONGDESC="Autoscript package for Amlogic devices"
PKG_TOOLCHAIN="manual"

make_target() {
  for src in $PKG_DIR/scripts/*autoscript.src ; do
    $TOOLCHAIN/bin/mkimage -A $TARGET_KERNEL_ARCH -O linux -T script -C none -d "$src" "$(basename $src .src)" > /dev/null
  done
}

makeinstall_target() {
  mkdir -p $INSTALL/instboot
  cp -a $PKG_BUILD/*autoscript $INSTALL/instboot
  cp -a $PKG_DIR/instboot/* $INSTALL/instboot
  for src in $INSTALL/instboot/*.ini ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"

      sed -e "s/@DTB_NAME@/$DEFAULT_DTB_NAME/g" \
          -i "$src"
  done
}
