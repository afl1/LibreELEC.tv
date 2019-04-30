# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="wireguard"
PKG_VERSION="0.0.20190406"
PKG_SHA256="2f06f3adf70b95e74a7736a22dcf6e9ef623b311a15b7d55b5474e57c3d0415b"
PKG_LICENSE="GPLv2"
PKG_SITE="https://www.wireguard.com"
PKG_URL="https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux libmnl"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="The WireGuard VPN kernel module"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

pre_make_target() {
  unset LDFLAGS
}

make_target() {
  kernel_make KERNELDIR=$(kernel_path) -C src/ module tools
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/wg-config $INSTALL/usr/bin
    cp $PKG_DIR/scripts/wg-quick $INSTALL/usr/bin
    cp $PKG_BUILD/src/tools/wg $INSTALL/usr/bin

  mkdir -p $INSTALL/usr/template
    cp $PKG_DIR/template/wg0.conf $INSTALL/usr/template
    cp $PKG_DIR/template/wgnet $INSTALL/usr/template

  mkdir -p $INSTALL/usr/config
    cp $PKG_DIR/config/wireguard.conf.sample $INSTALL/usr/config

  mkdir -p $INSTALL/etc/wireguard
    ln -sf /run/libreelec/wireguard/wg0.conf $INSTALL/etc/wireguard/wg0.conf

  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp src/*.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}

post_install() {
  enable_service wireguard-config.service
  enable_service wireguard.service
}
