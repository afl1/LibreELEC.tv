################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="u-boot"
PKG_VERSION="2017.09"
PKG_SHA256="b2d15f2cf5f72e706025cde73d67247c6da8cd35f7e10891eefe7d9095089744"
PKG_ARCH="arm aarch64"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_URL="ftp://ftp.denx.de/pub/u-boot/u-boot-$PKG_VERSION.tar.bz2"
PKG_SOURCE_DIR="u-boot-$PKG_VERSION"
PKG_DEPENDS_TARGET="toolchain dtc:host"
PKG_LICENSE="GPL"
PKG_SECTION="tools"
PKG_SHORTDESC="u-boot: Universal Bootloader project"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems, used as the default boot loader by several board vendors. It is intended to be easy to port and to debug, and runs on many supported architectures, including PPC, ARM, MIPS, x86, m68k, NIOS, and Microblaze."
PKG_AUTORECONF="no"
PKG_IS_KERNEL_PKG="yes"

make_target() {
  if [ -z "$UBOOT_SYSTEM" ]; then
    echo "UBOOT_SYSTEM must be set to build an image"
    echo "see './scripts/uboot_helper' for more information"
  else
    CROSS_COMPILE="$TARGET_PREFIX" LDFLAGS="" ARCH=arm make mrproper
    CROSS_COMPILE="$TARGET_PREFIX" LDFLAGS="" ARCH=arm make $($ROOT/$SCRIPTS/uboot_helper $PROJECT $DEVICE $UBOOT_SYSTEM config)
    CROSS_COMPILE="$TARGET_PREFIX" LDFLAGS="" ARCH=arm make HOSTCC="$HOST_CC" HOSTSTRIP="true"
  fi
}

make_target() {
  # get number of targets to build
  UBOOT_TARGET_CNT=0
  for UBOOT_TARGET in $UBOOT_CONFIG; do
    UBOOT_TARGET_CNT=$((UBOOT_TARGET_CNT + 1))
  done

  for UBOOT_TARGET in $UBOOT_CONFIG; do
    if [ "$UBOOT_VERSION" = "hardkernel" ]; then
      export PATH=$TOOLCHAIN/lib/gcc-linaro-aarch64-elf/bin/:$TOOLCHAIN/lib/gcc-linaro-arm-eabi/bin/:$PATH
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make mrproper
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make $UBOOT_TARGET
      CROSS_COMPILE=aarch64-elf- ARCH=arm CFLAGS="" LDFLAGS="" make HOSTCC="$HOST_CC" HOSTSTRIP="true"
    else
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm mrproper
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm $UBOOT_TARGET
      make CROSS_COMPILE="$TARGET_PREFIX" ARCH=arm HOSTCC="$HOST_CC" HOSTSTRIP="true"
    fi

    # Only install u-boot.img et al when building a board specific image
    if [ -n "$UBOOT_SYSTEM" ]; then
      if [ -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/install ]; then
        . $PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/install
      elif [ -f $PROJECT_DIR/$PROJECT/bootloader/install ]; then
        . $PROJECT_DIR/$PROJECT/bootloader/install
      fi
    fi

    # Always install the update script
    if [ -f $PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/update.sh ]; then
      cp -av $PROJECT_DIR/$PROJECT/devices/$DEVICE/bootloader/update.sh $INSTALL/usr/share/bootloader
    elif [ -f $PROJECT_DIR/$PROJECT/bootloader/update.sh ]; then
      cp -av $PROJECT_DIR/$PROJECT/bootloader/update.sh $INSTALL/usr/share/bootloader
    fi

  BOOT_CFG="$PROJECT_DIR/$PROJECT/bootloader/boot.cfg"
  if [ -r "$BOOT_CFG" ]; then
    cp $BOOT_CFG boot.cfg
    mkimage -A "$TARGET_ARCH" \
            -O u-boot \
            -T script \
            -C none \
            -n "$DISTRONAME Boot" \
            -d boot.cfg \
            $UBOOT_CONFIGFILE
  fi

  mkdir -p $INSTALL/usr/share/bootloader

  cp $PKG_BUILD/u-boot*.imx $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp $PKG_BUILD/u-boot*.img $INSTALL/usr/share/bootloader 2>/dev/null || :
  cp $PKG_BUILD/SPL* $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp $PKG_BUILD/$UBOOT_CONFIGFILE $INSTALL/usr/share/bootloader 2>/dev/null || :

  cp -PR $PROJECT_DIR/$PROJECT/bootloader/uEnv*.txt $INSTALL/usr/share/bootloader 2>/dev/null || :

  case $UBOOT_VERSION in
    hardkernel)
      cp -PRv $PKG_DIR/scripts/update-c2.sh $INSTALL/usr/share/bootloader/update.sh
      cp -PRv $PKG_BUILD/u-boot.bin $INSTALL/usr/share/bootloader/u-boot
      if [ -f $PROJECT_DIR/$PROJECT/bootloader/boot.ini ]; then
        cp -PRv $PROJECT_DIR/$PROJECT/bootloader/boot.ini $INSTALL/usr/share/bootloader
      fi
      if [ -f $PROJECT_DIR/$PROJECT/splash/boot-logo.bmp.gz ]; then
        cp -PRv $PROJECT_DIR/$PROJECT/splash/boot-logo.bmp.gz $INSTALL/usr/share/bootloader
      elif [ -f $DISTRO_DIR/$DISTRO/splash/boot-logo.bmp.gz ]; then
        cp -PRv $DISTRO_DIR/$DISTRO/splash/boot-logo.bmp.gz $INSTALL/usr/share/bootloader
      fi
      ;;
    imx6*)
      cp -PRv $PKG_DIR/scripts/update.sh $INSTALL/usr/share/bootloader
      ;;
  esac
}
