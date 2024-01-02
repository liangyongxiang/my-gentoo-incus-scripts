if [ "\${DISPLAY}" == ":0" ];then
    xrandr --auto
    xrdb -merge ~/.Xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "\$f" ] && . "\$f"
    done
    unset f
fi

export AWT_TOOLKIT=MToolkit
export TERM=st

if [ -f "/usr/bin/fcitx5" ]; then
    export GTK_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS=@im=fcitx
    export SDL_IM_MODULE=fcitx
    exec fcitx5 &
fi

if [ -f "/usr/bin/xbindkeys" ]; then
    exec xbindkeys &
fi

if [ -d "/usr/share/fonts/noto" ]; then
    xset +fp /usr/share/fonts/noto
    xset +fp /usr/share/fonts/noto-cjk
fi

exec dbus-launch --exit-with-session dwm
