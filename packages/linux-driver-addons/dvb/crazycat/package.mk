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

PKG_NAME="crazycat"
PKG_VERSION="2017-11-13"
PKG_SHA256="14d951eb8d40cee40d601d7c737bca07171d8b4f201d63d5e70a24c4841f9d73"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/crazycat69/linux_media"
PKG_URL="$DISTRO_SRC/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_BUILD_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SECTION="driver.dvb"
PKG_LONGDESC="DVB driver for TBS cards with CrazyCats additions."

PKG_IS_ADDON="yes"
PKG_ADDON_IS_STANDALONE="yes"
PKG_ADDON_NAME="DVB drivers for TBS (CrazyCat)"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_VERSION="${ADDON_VERSION}.${PKG_REV}"

if [ "$PROJECT" = "S905" ] || [ "$PROJECT" = "S912" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET dvb_tv-aml"
fi

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  export LDFLAGS=""
}

make_target() {
  make untar

  # copy config file
  if [ "$PROJECT" = Generic ]; then
    if [ -f $PKG_DIR/config/generic.config ]; then
      cp $PKG_DIR/config/generic.config v4l/.config
    fi
  elif [ "$PROJECT" != "S905" ] && [ "$PROJECT" != "S912" ]; then
    if [ -f $PKG_DIR/config/usb.config ]; then
      cp $PKG_DIR/config/usb.config v4l/.config
    fi
  else

    # Amlogic AMLVIDEO driver
    if [ -e "$(kernel_path)/drivers/amlogic/video_dev" ]; then
    
      # Copy, patch and enable amlvideodri module
      cp -a "$(kernel_path)/drivers/amlogic/video_dev" "linux/drivers/media/"
      sed -i 's,common/,,g; s,"trace/,",g' $(find linux/drivers/media/video_dev/ -type f)
      sed -i 's,\$(CONFIG_V4L_AMLOGIC_VIDEO),m,g' "linux/drivers/media/video_dev/Makefile"
      echo "obj-y += video_dev/" >> "linux/drivers/media/Makefile"
    
      # Copy and enable videobuf-res module
      cp -a "$(kernel_path)/drivers/media/v4l2-core/videobuf-res.c" "linux/drivers/media/v4l2-core/"
      cp -a "$(kernel_path)/include/media/videobuf-res.h" "linux/include/media/"
      echo "obj-m += videobuf-res.o" >> "linux/drivers/media/v4l2-core/Makefile"
    fi
    
    # Amlogic DVB drivers
    if [ "$PROJECT" = "S905" ] || [ "$PROJECT" = "S912" ]; then
      DVB_TV_AML_DIR="$(get_build_dir dvb_tv-aml)"
      if [ -d "$DVB_TV_AML_DIR" ]; then
        cp -a "$DVB_TV_AML_DIR" "linux/drivers/media/dvb_tv"
        echo "obj-y += dvb_tv/" >> "linux/drivers/media/Makefile"
      fi
      if [ "$PROJECT" = "S905" ]; then
        echo "obj-y += amlogic/dvb_tv/" >> "linux/drivers/media/Makefile"
        WETEKDVB_DIR="$(get_build_dir wetekdvb)"
        if [ -d "$WETEKDVB_DIR" ]; then
          cp -a "$WETEKDVB_DIR/wetekdvb.ko" "v4l/"
        fi
      fi
    fi
  fi

  # add menuconfig to edit .config
  make VER=$KERNEL_VER SRCDIR=$(kernel_path)
}

makeinstall_target() {
  install_driver_addon_files "$PKG_BUILD/v4l/"
}
