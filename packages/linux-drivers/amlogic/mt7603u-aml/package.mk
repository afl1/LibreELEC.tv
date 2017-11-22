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

PKG_NAME="mt7603u-aml"
PKG_REV="1"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/wifi/"
PKG_VERSION="0c53dfb"
PKG_SHA256="9e3eab02f3c3dd7de373c5d631c2069771e6ad783ecda36a484030ab4ec0ccec"
PKG_URL="https://github.com/khadas/android_hardware_wifi_mtk_drivers_mt7603/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="android_hardware_wifi_mtk_drivers_mt7603-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="mt7603u-aml"
PKG_LONGDESC="mt7603u-aml"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  LDFLAGS="" make LINUX_SRC=$(kernel_path) ARCH=$TARGET_KERNEL_ARCH CROSS_COMPILE=$TARGET_PREFIX RT28xx_DIR=$PKG_BUILD -f $PKG_BUILD/Makefile
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $PKG_BUILD/os/linux/mtprealloc.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $PKG_BUILD/os/linux/mt7603usta.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME

  mkdir -p $INSTALL/$(get_full_firmware_dir)
  cp $PKG_BUILD/conf/MT7603USTA.dat $INSTALL/$(get_full_firmware_dir)
}
