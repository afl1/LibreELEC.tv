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

PKG_NAME="aml_linux_fd628"
PKG_VERSION="1.0"
PKG_SHA256=""
PKG_ARCH="arm aarch64"
PKG_LICENSE="free"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver"
PKG_SHORTDESC="Amlogic Linux FD628 Driver"
PKG_LONGDESC="Amlogic Linux FD628 Driver"
PKG_TOOLCHAIN="manual"

make_target() {
  echo "$CC $CFLAGS -Wall $LDFLAGS -lm -lpthread -o FD628Service FD628Service.c"
  $CC $CFLAGS -Wall $LDFLAGS -lm -lpthread -o FD628Service FD628Service.c
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/sbin
    cp FD628Service $INSTALL/usr/sbin/FD628Service

  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
    cp $PKG_DIR/sources/aml_linux_fd628.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}

post_install() {
  enable_service fd628.service
}
