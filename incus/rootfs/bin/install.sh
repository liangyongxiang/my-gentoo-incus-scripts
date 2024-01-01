#!/usr/bin/env bash

# shellcheck source=../lib/lib.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/lib.sh"

emerge_install_script() {
    local script="$1"

    case "$script" in
        --install-dev)
            flaggie "sys-apps/util-linux" "+caps"
            local dev_packages=(
                app-editors/vim
                app-portage/eix
                app-portage/gentoolkit
                app-portage/iwdevtools
                app-portage/pfl
                app-portage/pkg-testing-tools
                app-portage/portage-utils
                app-text/ansifilter
                dev-util/pkgcheck
                dev-util/pkgdev
                sys-process/htop
            )
            emerge --noreplace "${dev_packages[@]}"
            rsync --chown=root:root /root/etc/portage/bashrc /etc/portage/bashrc
            rsync --chown=root:root /root/etc/portage/env /etc/portage/env
            ;;

        --install-dwm)
            flaggie media-libs/mesa +video_cards_virgl
            emerge --oneshot media-libs/mesa
            local dev_packages=(
                x11-base/xorg-server
                x11-misc/dmenu
                x11-terms/st
                x11-wm/dwm
            )
            emerge --noreplace "${dev_packages[@]}"

            local new_user="user"
            if ! id "$new_user"; then
                useradd -m -G users,wheel,audio -s /bin/bash "$new_user"
                passwd -d "$new_user"
            fi

            local file="/home/user/.xinitrc"
            rsync --chown="$new_user:$new_user" "/root${file}" "$file"
            ;;

        --install-fcitx5)
            flaggie x11-libs/xcb-imdkit +~amd64
            flaggie app-i18n/fcitx +~amd64
            flaggie app-i18n/fcitx-qt +~amd64
            flaggie app-i18n/fcitx-gtk +~amd64
            flaggie app-i18n/fcitx-configtool +~amd64
            flaggie app-i18n/fcitx-chinese-addons +~amd64
            flaggie app-i18n/libime +~amd64
            flaggie app-i18n/fcitx-lua +~amd64
            flaggie app-i18n/fcitx-table-extra +~amd64
            flaggie app-i18n/fcitx-other +~amd64

            flaggie app-i18n/fcitx-chinese-addons +lua

            local dev_packages=(
                app-i18n/fcitx
                app-i18n/fcitx-chinese-addons
                app-i18n/fcitx-configtool
            )
            emerge --noreplace "${dev_packages[@]}"
            ;;
        *)
            local file
            file="$(dirname "${BASH_SOURCE[0]}")/${1#--}.sh"
            if [ -f "$file" ]; then
                source "$file"
            fi
            ;;
    esac

}

emerge_install_script "$@"

