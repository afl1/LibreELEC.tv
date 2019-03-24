# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="mesa"
PKG_LICENSE="OSS"
PKG_SITE="http://www.mesa3d.org/"
PKG_DEPENDS_TARGET="toolchain expat libdrm Mako:host"
PKG_LONGDESC="Mesa is a 3-D graphics library with an API."
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+lto"

case $PROJECT in
  Amlogic)
    case $DEVICE in
      Khadas_VIM2|Nexbox_A1|S912)
        PKG_VERSION="d258b787faaf9b089acd740df26bddbb64c2c630" # master-19.1
        PKG_SHA256="d0189c204029225b5a269b6dcea25c937397c3539531edcb947f19fae4f4da3a"
        PKG_URL="https://gitlab.freedesktop.org/mesa/mesa/-/archive/$PKG_VERSION/mesa-$PKG_VERSION.tar.gz"
        PKG_PATCH_DIRS="panfrost"
        ;;
      *)
        PKG_VERSION="00d67e27d9548eefb9d5e89b896d4b719adeed3b" # lima-18.3
        PKG_SHA256="51afd8fcc31dac0e18b749eef3a9307b9f7ce43994cb9e0e7565ecf00db798d0"
	PKG_URL="https://gitlab.freedesktop.org/lima/mesa/-/archive/$PKG_VERSION/mesa-$PKG_VERSION.tar.gz"
	;;
    esac
    ;;
  *)
    PKG_VERSION="19.0.0"
    PKG_SHA256="9e513e10d865fa3546588ec68b6428da5177bcab30a6a1a93d6c1dc25bd21c29"
    PKG_URL="https://github.com/mesa3d/mesa/archive/mesa-$PKG_VERSION.tar.gz"
    ;;
esac

get_graphicdrivers

PKG_MESON_OPTS_TARGET="-Ddri-drivers=$DRI_DRIVERS \
                       -Dgallium-drivers=$GALLIUM_DRIVERS \
                       -Dgallium-extra-hud=false \
                       -Dgallium-xvmc=false \
                       -Dgallium-omx=disabled \
                       -Dgallium-nine=false \
                       -Dgallium-opencl=disabled \
                       -Dvulkan-drivers= \
                       -Dshader-cache=true \
                       -Dshared-glapi=true \
                       -Dopengl=true \
                       -Dgbm=true \
                       -Degl=true \
                       -Dglvnd=false \
                       -Dasm=true \
                       -Dvalgrind=false \
                       -Dlibunwind=false \
                       -Dlmsensors=false \
                       -Dbuild-tests=false \
                       -Dselinux=false \
                       -Dosmesa=none"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET xorgproto libXext libXdamage libXfixes libXxf86vm libxcb libX11 libxshmfence libXrandr"
  export X11_INCLUDES=
  PKG_MESON_OPTS_TARGET+=" -Dplatforms=x11,drm -Ddri3=true -Dglx=dri"
elif [ "$DISPLAYSERVER" = "weston" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET wayland wayland-protocols"
  PKG_MESON_OPTS_TARGET+=" -Dplatforms=wayland,drm -Ddri3=false -Dglx=disabled"
else
  PKG_MESON_OPTS_TARGET+=" -Dplatforms=drm -Ddri3=false -Dglx=disabled"
fi

if [ "$LLVM_SUPPORT" = "yes" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET elfutils llvm"
  export LLVM_CONFIG="$SYSROOT_PREFIX/usr/bin/llvm-config-host"
  PKG_MESON_OPTS_TARGET+=" -Dllvm=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dllvm=false"
fi

if [ "$VDPAU_SUPPORT" = "yes" -a "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
  PKG_MESON_OPTS_TARGET+=" -Dgallium-vdpau=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dgallium-vdpau=false"
fi

if [ "$VAAPI_SUPPORT" = "yes" ] && listcontains "$GRAPHIC_DRIVERS" "(r600|radeonsi)"; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva"
  PKG_MESON_OPTS_TARGET+=" -Dgallium-va=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dgallium-va=false"
fi

if listcontains "$GRAPHIC_DRIVERS" "vmware"; then
  PKG_MESON_OPTS_TARGET+=" -Dgallium-xa=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dgallium-xa=false"
fi

if [ "$OPENGLES_SUPPORT" = "yes" ]; then
  PKG_MESON_OPTS_TARGET+=" -Dgles1=false -Dgles2=true"
else
  PKG_MESON_OPTS_TARGET+=" -Dgles1=false -Dgles2=false"
fi

# Temporary workaround:
# Listed libraries are static, while mesa expects shared ones. This breaks the
# dependency tracking. The following has some ideas on how to address that.
# https://github.com/LibreELEC/LibreELEC.tv/pull/2163
pre_configure_target() {
  if [ "$DISPLAYSERVER" = "x11" ]; then
    export LIBS="-lxcb-dri3 -lxcb-dri2 -lxcb-xfixes -lxcb-present -lxcb-sync -lxshmfence -lz"
  fi
}

post_makeinstall_target() {
  # Similar hack is needed on EGL, GLES* front. Might as well drop it and test the GLVND?
  if [ "$DISPLAYSERVER" = "x11" ]; then
    # rename and relink for cooperate with nvidia drivers
    rm -rf $INSTALL/usr/lib/libGL.so
    rm -rf $INSTALL/usr/lib/libGL.so.1
    ln -sf libGL.so.1 $INSTALL/usr/lib/libGL.so
    ln -sf /var/lib/libGL.so $INSTALL/usr/lib/libGL.so.1
    mv $INSTALL/usr/lib/libGL.so.1.2.0 $INSTALL/usr/lib/libGL_mesa.so.1
  fi
}
