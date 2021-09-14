#!/bin/bash
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
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

TMP_FONTDIR="$(mktemp -dt "cyphar-dotfiles-fonts.XXXXXXXX")"
trap "rm -rf '$TMP_FONTDIR'" EXIT

# Install Cozette.
# TODO: Switch to using the latest version rather than a hard-coded one.
FONT_URL="https://github.com/slavfox/Cozette/releases/download/v.1.9.3/CozetteFonts.zip"
curl -L "$FONT_URL" -o "$TMP_FONTDIR/CozetteFonts.zip"
(
	cd "$TMP_FONTDIR"
	unzip CozetteFonts.zip
	sudo install -m0644 -t /usr/share/fonts/truetype CozetteFonts/*.{ttf,otf,otb}
)
fc-cache -fv

# CJK fonts.
fonts=(
	mplus-fonts
	monapo-fonts
	noto-sans-gothic-fonts
	noto-sans-{jp,tc,sc,kr}-fonts-full
	ipa-{{ex-,p}{gothic,mincho},uigothic,{,p}gothic-{bold,italic,bolditalic}}-fonts
	adobe-sourcehan{serif,sans}-{cn,jp,kr,tw}-fonts
)
sudo zypper install -y "${fonts[@]}"
