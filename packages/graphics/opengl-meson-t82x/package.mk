################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
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

PKG_NAME="opengl-meson-t82x"
PKG_VERSION="076f89d"
PKG_SHA256="a90e0af3921eade81847c96c45e1ed4855007f70763442bd18f2872a38c3174a"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/kszaq/opengl-meson-t82x"
PKG_URL="https://github.com/kszaq/opengl-meson-t82x/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libhybris"
PKG_SOURCE_DIR="$PKG_NAME-$PKG_VERSION*"
PKG_SECTION="graphics"
PKG_SHORTDESC="opengl-meson: OpenGL ES pre-compiled libraries for Mali GPUs found in Amlogic Meson SoCs"
PKG_LONGDESC="opengl-meson: OpenGL ES pre-compiled libraries for Mali GPUs found in Amlogic Meson SoCs. The libraries could be found in a Linux buildroot released by Amlogic at http://openlinux.amlogic.com:8000/download/ARM/filesystem/. See the opengl package."
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include
    cp -PR usr/include/* $SYSROOT_PREFIX/usr/include

  mkdir -p $INSTALL/system
    cp -a system/* $INSTALL/system
}

post_install() {
  enable_service unbind-console.service
}
