# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mali-bifrost"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/bifrost-kernel"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_LONGDESC="mali-midgard: the Linux kernel driver for ARM Mali Midgard GPUs"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

case $PROJECT in
  Amlogic|ACME)
    PKG_VERSION="9a38390caba51827d47a3bac1304a55033e4b6d4" #r16p0
    PKG_SHA256="67a1195762f86ac8f0eba52e648a20bbdb7d4ba0784f767bcf96bf38e4d97872"
    PKG_URL="https://github.com/chewitt/mali-bifrost/archive/$PKG_VERSION.tar.gz"
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
