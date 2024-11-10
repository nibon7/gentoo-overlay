#!/bin/sh

if [ "$XDG_SESSION_TYPE" = "wayland" ];then
  export XDG_SESSION_TYPE=x11
  export EGL_PLATFORM=x11
  export QT_QPA_PLATFORM=xcb
  unset WAYLAND_DISPLAY
fi

SELF=$(readlink -f "$0")
HERE=${SELF%/*}

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export IBUS_USE_PORTAL=1

export PATH="${HERE}/bin${PATH:+:$PATH}"
export LD_LIBRARY_PATH="${HERE}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export QT_PLUGIN_PATH="${HERE}/plugins"

exec wemeetapp $*
