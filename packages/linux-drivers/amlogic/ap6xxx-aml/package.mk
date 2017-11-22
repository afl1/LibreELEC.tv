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

PKG_NAME="ap6xxx-aml"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_VERSION="99b3459"
PKG_SHA256="5f2bfc29616d869ad5fb41e0782887d73cafe0bae8a13e7e945bb32b2a2c0877"
PKG_URL="https://github.com/khadas/android_hardware_wifi_broadcom_drivers_ap6xxx/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="android_hardware_wifi_broadcom_drivers_ap6xxx-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="ap6xxx-aml: Linux drivers for AP6xxx WLAN chips used in some devices based on Amlogic SoCs"
PKG_LONGDESC="ap6xxx-aml: Linux drivers for AP6xxx WLAN chips used in some devices based on Amlogic SoCs"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  LDFLAGS="" make -C $(kernel_path) M=$PKG_BUILD/bcmdhd.1.363.59.144.x.cn \
    ARCH=$TARGET_KERNEL_ARCH \
    CROSS_COMPILE=$TARGET_PREFIX
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $PKG_BUILD/bcmdhd.1.363.59.144.x.cn/dhd.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}
