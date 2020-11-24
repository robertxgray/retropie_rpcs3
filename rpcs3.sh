#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="rpcs3"
rp_module_desc="PS3 emulator RPCS3"
rp_module_help="ROM Extensions: .ps3\n\nCopy your .PS3 game folders to $romdir/ps3\n\nDon't forget to run system firmware update first!"
rp_module_licence="GPL2 https://raw.githubusercontent.com/RPCS3/rpcs3/master/LICENSE"
rp_module_section="exp"
rp_module_flags="!arm"

function install_bin_rpcs3() {
    mkdir -p "$md_inst/bin"
    wget --content-disposition https://rpcs3.net/latest-appimage -O "$md_inst/bin/rpcs3.AppImage"
    chmod +x "$md_inst/bin/rpcs3.AppImage"

    echo '#!/bin/bash
if [ -f "${1}" ]
then
	GAME_ID=$(cat "${1}")
	EBOOT="${HOME}/.config/rpcs3/dev_hdd0/game/${GAME_ID}/USRDIR/EBOOT.BIN"
else
	EBOOT="${1}/PS3_GAME/USRDIR/EBOOT.BIN"
fi
exec "'$md_inst'/bin/rpcs3.AppImage" --no-gui "${EBOOT}"
' > "$md_inst/bin/rpcs3.sh"
    chmod +x "$md_inst/bin/rpcs3.sh"
}

function configure_rpcs3() {
    mkRomDir "ps3"
    addEmulator 0 "$md_id" "ps3" "$md_inst/bin/rpcs3.AppImage %ROM%/PS3_GAME/USRDIR/EBOOT.BIN"
    addEmulator 1 "$md_id-nogui" "ps3" "$md_inst/bin/rpcs3.AppImage --no-gui %ROM%/PS3_GAME/USRDIR/EBOOT.BIN"
    addEmulator 2 "$md_id-script" "ps3" "$md_inst/bin/rpcs3.sh %ROM%"
    addSystem "ps3"
}
