# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mali-utgard-rockchip"
PKG_VERSION="r9p0-01rel0"
PKG_SHA256="7a67127341d17640c1fff5dad80258fb2a37c8a2121b81525fe2327e4532ce2b"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://developer.arm.com/products/software/mali-drivers/utgard-kernel"
PKG_URL="https://armkeil.blob.core.windows.net/developer/Files/downloads/mali-drivers/kernel/mali-utgard-gpu/DX910-SW-99002-$PKG_VERSION.tgz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="mali-utgard-rockchip: Linux drivers for Mali Utgard GPUs found in Rockchip SoCs"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  kernel_make -C $(kernel_path) M=$PKG_BUILD/driver/src/devicedrv/mali \
    MALI_PLATFORM_FILES=platform/rk/rk.c GIT_REV="" \
    EXTRA_CFLAGS="-DCONFIG_MALI400=1 -DCONFIG_MALI450=1 -DCONFIG_MALI470=1 -DMALI_FAKE_PLATFORM_DEVICE=1 -DCONFIG_MALI_DMA_BUF_MAP_ON_ATTACH -DCONFIG_MALI_DT" \
    CONFIG_MALI400=m CONFIG_MALI450=y CONFIG_MALI470=y CONFIG_MALI_DMA_BUF_MAP_ON_ATTACH=y CONFIG_MALI_DT=y \
    modules
}

makeinstall_target() {
  kernel_make -C $(kernel_path) M=$PKG_BUILD/driver/src/devicedrv/mali \
    INSTALL_MOD_PATH=$INSTALL/$(get_kernel_overlay_dir) INSTALL_MOD_STRIP=1 DEPMOD=: \
    modules_install
}
