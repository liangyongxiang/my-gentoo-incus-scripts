#!/usr/bin/env bash

main_tree_switch_to_git() {
    if ! portageq repos_config / | grep -E 'sync-type.*git' &>/dev/null; then
        emerge dev-vcs/git app-eselect/eselect-repository
        eselect repository remove gentoo
        eselect repository enable gentoo
    fi
    local repo="/var/db/repos/gentoo"
    if ! git -C "$repo" rev-parse &> /dev/null; then
        rm -rf "$repo" && mkdir "$repo"
        git -C "$repo" clone /root/repos/gentoo .  # cloneing speed up
    fi
}

makeconf_update() {
    local key="${1}"
    local value="${2}"
    python "$(dirname "${BASH_SOURCE[0]}")/makeconf.py" "$key" "$value"
}

main() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --init-gentoo-repo)
                main_tree_switch_to_git
                shift
                ;;
            --sync)
                emerge --sync
                shift
                ;;
            --update)
                emerge --update --deep --newuse --backtrack=300 @world
                shift
                ;;
            --depclean)
                emerge --depclean
                shift
                ;;
            --init-make-conf-base)
                makeconf_update "FEATURES"             "buildpkg"
                makeconf_update "COMMON_FLAGS"         "-O2 -pipe -ggdb -fdiagnostics-color=always -frecord-gcc-switches"
                makeconf_update "LDFLAGS"              "\${LDFLAGS} -Wl,--defsym=__gentoo_check_ldflags__=0"
                makeconf_update "PORTAGE_ELOG_CLASSES" "warn error info log qa"
                makeconf_update "PORTAGE_ELOG_SYSTEM"  "save"
                makeconf_update "EMERGE_DEFAULT_OPTS"  "--verbose --quiet --autounmask-continue --autounmask-write"
                makeconf_update "GENTOO_MIRRORS"       "https://mirrors.bfsu.edu.cn/gentoo/"
                makeconf_update "MAKEOPTS"             "--jobs $(nproc) --load-average $(( $(nproc) + 1 ))"
                makeconf_update "ACCEPT_LICENSE"       "*"
                makeconf_update "GRUB_PLATFORMS"       "efi-64"
                makeconf_update "BINPKG_FORMAT"        "gpkg"
                shift
                ;;
            --init-all-targets)
                makeconf_update "LUA_SINGLE_TARGET"    "lua5-1"
                makeconf_update "LUA_TARGETS"          "lua5-1 lua5-2 lua5-3 lua5-4"
                makeconf_update "PYTHON_SINGLE_TARGET" "python3_11"
                makeconf_update "PYTHON_TARGETS"       "python3_10 python3_11 python3_12"
                makeconf_update "RUBY_TARGETS"         "ruby30 ruby31"
                shift
                ;;
            --init-testing)
                makeconf_update 'ACCEPT_KEYWORDS' "~$(portageq envvar ARCH)"
                emerge --update --deep --newuse --backtrack=300 @world
                shift
                ;;
            --install-essential-tool)
                emerge --noreplace app-eselect/eselect-repository app-portage/flaggie
                shift
                ;;
            --install-dev-tool)
                emerge --noreplace app-eselect/eselect-repository app-portage/flaggie
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
                shift
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
                flaggie app-i18n/fcitx-table-other +~amd64

                flaggie app-i18n/fcitx-chinese-addons +lua

                local dev_packages=(
                    app-i18n/fcitx
                    app-i18n/fcitx-chinese-addons
                    app-i18n/fcitx-configtool
                )
                emerge --noreplace "${dev_packages[@]}"
                ;;
            --*)
                echo "Unknown options: $1"
                break
                ;;
            *)
                "$@"
                break;
                ;;
        esac
    done
}

main "$@"
