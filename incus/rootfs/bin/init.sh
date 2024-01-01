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

case "$1" in
    minial)
        run_base=true
        run_makeconfg_base=false
        run_makeconf_all_targets=false
        run_makeconfig_testing=false
        ;;
    stable)
        run_base=true
        run_makeconfg_base=true
        run_makeconf_all_targets=false
        run_makeconfig_testing=false
        ;;
    stable-all)
        run_base=true
        run_makeconfg_base=true
        run_makeconf_all_targets=true
        run_makeconfig_testing=false
        ;;
    testing)
        run_base=true
        run_makeconfg_base=true
        run_makeconf_all_targets=false
        run_makeconfig_testing=true
        ;;
    testing-all)
        run_base=true
        run_makeconfg_base=true
        run_makeconf_all_targets=true
        run_makeconfig_testing=true
        ;;
    *)
        echo "Unknown Options"
        exit 1
        ;;
esac

if "$run_makeconfig_testing"; then
    makeconf_update 'ACCEPT_KEYWORDS' "~$(portageq envvar ARCH)"
fi

if "$run_makeconf_all_targets"; then
    makeconf_update 'LUA_SINGLE_TARGET'    '"lua5-1"'
    makeconf_update 'LUA_TARGETS'          '"lua5-1 lua5-2 lua5-3 lua5-4"'
    makeconf_update 'PYTHON_SINGLE_TARGET' '"python3_11"'
    makeconf_update 'PYTHON_TARGETS'       '"python3_10 python3_11 python3_12"'
    makeconf_update 'RUBY_TARGETS'         '"ruby30 ruby31"'
fi

if "$run_makeconfg_base"; then
    makeconf_update "FEATURES"             "buildpkg"
    makeconf_update "COMMON_FLAGS"         "-O2 -pipe -ggdb -fdiagnostics-color=always -frecord-gcc-switches"
    makeconf_update "LDFLAGS"              "\${LDFLAGS} -Wl,--defsym=__gentoo_check_ldflags__=0"
    makeconf_update "PORTAGE_ELOG_CLASSES" "warn error info log qa"
    makeconf_update "PORTAGE_ELOG_SYSTEM"  "save"
    makeconf_update "EMERGE_DEFAULT_OPTS"  "--verbose --quiet --noreplace --autounmask-continue --autounmask-write"
    makeconf_update "GENTOO_MIRRORS"       "https://mirrors.bfsu.edu.cn/gentoo/"
    makeconf_update "MAKEOPTS"             "--jobs $(nproc) --load-average $(( $(nproc) + 1 ))"
    makeconf_update "ACCEPT_LICENSE"       "*"
    makeconf_update "GRUB_PLATFORMS"       "efi-64"
    makeconf_update "BINPKG_FORMAT"        "gpkg"
fi

if "$run_base"; then
    main_tree_switch_to_git
    emerge --sync
    emerge --update --deep --newuse --backtrack=300 @world
    emerge --noreplace app-eselect/eselect-repository app-portage/flaggie
fi
