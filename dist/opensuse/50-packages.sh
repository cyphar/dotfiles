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

# Remove the proprietary repos (if they're enabled).
echo ">> zypper removerepo [proprietary]"
sudo zypper removerepo repo-non-oss || true

# Upgrade the priority of the built-in repos.
echo ">> zypper modifyrepo [upgrade builtin priority]"
sudo zypper mr -p 98 repo-debug repo-oss repo-source repo-update

# Set of repos needed for a base system.
echo ">> zypper addrepo [repos]"
zypper repos packman-essentials &>/dev/null || sudo zypper addrepo -fp 97 "https://ftp.gwdg.de/pub/linux/misc/packman/suse/$OPENSUSE_DISTRO/Essentials" packman-essentials
zypper repos obs-fs             &>/dev/null || sudo zypper addrepo -f "obs://filesystems" obs-fs
zypper repos obs-hardware       &>/dev/null || sudo zypper addrepo -f "obs://hardware" obs-hardware
zypper repos obs-vc             &>/dev/null || sudo zypper addrepo -fp 97 "obs://Virtualization:containers" obs-vc
sudo zypper --gpg-auto-import-keys ref

# Set of packages we need for a base system.
# TODO: Make it possible to specify whether it's a workstation or server.

echo ">> zypper install [packages]"
packages=(
	# Basic cli tools necessary.
	"neovim" "tmux" "zsh" "git" "gcc" "go" "keychain" "figlet" "gpg2" "python3"
	"mosh" "rsync" "ranger" "alsa-utils" "weechat" "make" "exfat-utils"
	"fuse-exfat" "xfsprogs" "autoconf" "automake" "libtool" "bpftrace"
	"moreutils" "qpdf" "python3"
	# Container-related packages.
	"skopeo" "umoci" "runc" "docker" "lxc" "lxd"
	# Basic graphics stack and environment.
	"i3" "i3lock" "i3status" "dmenu" "feh" "ImageMagick" "xorg-x11-server"
	"xf86-video-intel" "xf86-input-keyboard" "xf86-input-mouse" "picom"
	"xf86-input-libinput" "lightdm" "lightdm-gtk-greeter" "cozette-fonts"
	"xbacklight" "xclip" "scrot"
	# Graphical programs.
	"keepassxc" "firefox" "vlc" "mpv" "alacritty" "redshift" "libreoffice"
	"zathura" "evince"
	# To make my phone work...
	"android-tools"
	# Networking.
	"wireguard-tools" "net-tools-deprecated" "NetworkManager-applet"
	# Good-to-haves.
	"torbrowser-launcher" "tor" "sshfs"
	# Mutt and related packages.
	"neomutt" "zenity" "isync" "secret-tool" "notmuch"
	# openSUSE
	"osc"
	# Japanese input and packages.
	"qolibri" ibus{,-gtk{,3},-mozc{,-candidate-window}}
)
sudo zypper install "${packages[@]}"

# Install rust with rustup. I don't like "curl | sh" either, and they don't
# seem to have any signature verification either. Hopefully they fix this soon
# <https://github.com/rust-lang/rustup/issues/2028>.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
"$HOME/.cargo/bin/rustup" toolchain install nightly

# Install diceware, patatt and b4 for kernel development.
sudo python3 -m ensurepip
sudo pip3 install diceware patatt b4
