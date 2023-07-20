#!/bin/bash
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2023 Aleksa Sarai <cyphar@cyphar.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -Eeuo pipefail

# TODO: Figure out how to handle my Japanese keyboard Thinkpad...

echo ">> configuring japanese keyboards in X11"
# Add an Xorg config to correctly configure my Japanese keyboard as Japanese
# but the system keyboard as English.
sudo tee /etc/X11/xorg.conf.d/90-jp-keyboards.conf >/dev/null <<EOF
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "en"
        Option "XkbModel" "thinkpad"
        Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection

Section "InputClass"
        Identifier "Logitech ERGO K860"
        MatchIsKeyboard "on"
        Option "XkbLayout" "jp"
        Option "XkbModel" "microsoftpro"
        Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection

Section "InputClass"
        Identifier "MOBO K2TF83J Keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "jp"
EndSection
EOF

# setxkbmap_name <keyboard name> [<setxkbmap options>...]
function setxkbmap_name() {
	device_name="keyboard:$1"
	shift
	device_id="$(xinput list --id-only "$device_name" ||:)"
	if [ -n "$device_id" ]
	then
		setxkbmap -device "$device_id" "$@"
	fi
}

# Apply the above settings to the running system.
echo ">> configuring live system's japanese keyboards"
setxkbmap_name "Logitech ERGO K860" -layout jp -model microsoftpro -option "terminate:ctrl_alt_bks"
setxkbmap_name "MOBO K2TF83J Keyboard" -layout jp
