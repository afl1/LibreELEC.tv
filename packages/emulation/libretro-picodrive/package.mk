################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2016-present Team LibreELEC
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

PKG_NAME="libretro-picodrive"
PKG_VERSION="fb53a52"
PKG_SHA256="4c9b7620394908ffa7c8d6c62345ca01b514d072265cb5de7864251d027e06d3"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/picodrive"
PKG_URL="https://github.com/libretro/picodrive/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="picodrive-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain kodi-platform $PKG_NAME:host"
PKG_DEPENDS_HOST="cyclone68000"
PKG_SECTION="emulation"
PKG_SHORTDESC="Fast MegaDrive/MegaCD/32X emulator"
PKG_LONGDESC="Fast MegaDrive/MegaCD/32X emulator"
PKG_TOOLCHAIN="manual"

PKG_LIBNAME="picodrive_libretro.so"
PKG_LIBPATH="$PKG_LIBNAME"
PKG_LIBVAR="PICODRIVE_LIB"

pre_build_host() {
  cp -a $(get_build_dir cyclone68000)/* $PKG_BUILD/cpu/cyclone/
}

pre_configure_host() {
  # fails to build in subdirs
  cd $PKG_BUILD
  rm -rf .$HOST_NAME
}

make_host() {
  if [ "$ARCH" == "arm" ]; then
    make -C cpu/cyclone CONFIG_FILE=../cyclone_config.h
  fi
}

pre_configure_target() {
  # fails to build in subdirs
  cd $PKG_BUILD
  rm -rf .$TARGET_NAME
}

configure_target() {
  strip_gold
}

make_target() {
  make -f Makefile.libretro
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME
  cp $PKG_LIBPATH $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME
  echo "set($PKG_LIBVAR $SYSROOT_PREFIX/usr/lib/$PKG_LIBNAME)" > $SYSROOT_PREFIX/usr/lib/cmake/$PKG_NAME/$PKG_NAME-config.cmake
}
