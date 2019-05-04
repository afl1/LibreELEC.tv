# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mali-bifrost"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_VERSION="064b0df037b19d47064880fdceed046680b9a63b" #r16p0
PKG_SHA256="96c0bf96e0c5f6a5cf6ef37e600078f130200a5b0fcc84f00c437a155a3cf4e9"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/bifrost-kernel"
PKG_URL="https://github.com/chewitt/mali-bifrost/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_LONGDESC="mali-midgard: the Linux kernel driver for ARM Mali Midgard GPUs"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

case $PROJECT in
  Amlogic)
    PKG_MALI_PLATFORM_CONFIG="config.meson-g12a"
    ;;
esac

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  make ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_KERNEL_PREFIX KDIR=$(kernel_path) \
       CONFIG_NAME=$PKG_MALI_PLATFORM_CONFIG -C $PKG_BUILD
}

makeinstall_target() {
  DRIVER_DIR=$PKG_BUILD/driver/product/kernel/drivers/gpu/arm/midgard/

  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp $DRIVER_DIR/mali_kbase.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME/
}
