# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="media_tree"
PKG_VERSION="2018-10-19-3b796aa60af0"
#PKG_SHA256="8df4e76878239881cf69bddab2f1c69be698c25682d114b706d75123972c95b7"
PKG_LICENSE="GPL"
PKG_SITE="https://git.linuxtv.org/media_tree.git"
PKG_URL="http://linuxtv.org/downloads/drivers/linux-media-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_LONGDESC="Source of Linux Kernel media_tree subsystem to build with media_build."
PKG_TOOLCHAIN="manual"

unpack() {
  mkdir -p $PKG_BUILD/
  tar -xf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.bz2 -C $PKG_BUILD/

  # hack/workaround for borked upstream kernel/media_build
  # without removing atomisp there a lot additional includes that 
  # slowdown build process after modpost from 3min to 6min
  # even if atomisp is disabled via kernel.conf
  rm -rf $PKG_BUILD/drivers/staging/media/atomisp
  sed -i 's|^.*drivers/staging/media/atomisp.*$||' \
    $PKG_BUILD/drivers/staging/media/Kconfig
  if [ "$PROJECT" = "Amlogic" ]; then
    cp -rL $(get_build_dir linux)/drivers/media/platform/meson/vdec $PKG_BUILD/drivers/media/platform/meson/
    cp -rL $(get_build_dir media_tree_aml)/drivers/media/platform/meson/dvb $PKG_BUILD/drivers/media/platform/meson/
    rm $PKG_BUILD/drivers/media/platform/qcom/venus/*.c
    rm $PKG_BUILD/drivers/media/platform/qcom/venus/*.h
    echo "obj-y += dvb/" >> "$PKG_BUILD/drivers/media/platform/meson/Makefile"
    echo "obj-y += vdec/" >> "$PKG_BUILD/drivers/media/platform/meson/Makefile"
  fi

}
