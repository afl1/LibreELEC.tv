# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="aml-autoscript"
PKG_VERSION="1.0"
PKG_LICENSE="GPL"
PKG_DEPENDS_TARGET="toolchain u-boot-tools-aml"
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

  for src in $INSTALL/instboot/extlinux/*.conf ; do
      sed -e "s/@BOOT_LABEL@/$DISTRO_BOOTLABEL/g" \
          -e "s/@DISK_LABEL@/$DISTRO_DISKLABEL/g" \
          -i "$src"

      sed -e "s/@DTB_NAME@/$DEFAULT_DTB_NAME/g" \
          -i "$src"
  done
}
