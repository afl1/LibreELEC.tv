################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
#      Copyright (C) 2017 kszaq
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="qca9377-aml"
PKG_REV="1"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="https://boundarydevices.com/new-silex-wifi-802-11ac-bt4-1-module/"
PKG_VERSION="8e1b647"
PKG_SHA256="7d9cffcc1694f274151eb2f755603515493c2f4d81fcf6a3fe3d87c587965a98"
PKG_URL="https://github.com/boundarydevices/qcacld-2.0/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="qcacld-2.0-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="qca9377-aml"
PKG_LONGDESC="qca9377-aml"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

post_unpack() {
  sed -i 's,-Wall,,g; s,-Werror,,g' $PKG_BUILD/Kbuild
  sed -i 's,CDEFINES :=,CDEFINES := -Wno-misleading-indentation -Wno-unused-variable -Wno-unused-function,g' $PKG_BUILD/Kbuild
}

make_target() {
  KERNEL_SRC="$(kernel_path)" ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_PREFIX \
    LDFLAGS="" CFLAGS="" CONFIG_CLD_HL_SDIO_CORE=y make
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $PKG_BUILD/wlan.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}
