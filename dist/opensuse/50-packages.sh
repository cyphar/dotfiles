#!/bin/bash
# dotfiles: collection of my personal dotfiles [code]
# Copyright (C) 2017-2018 Aleksa Sarai <cyphar@cyphar.com>
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

set -e

# Remove the proprietary repos (if they're enabled).
echo ">> zypper removerepo [proprietary]"
sudo zypper removerepo repo-non-oss || true

# Upgrade the priority of the built-in repos.
echo ">> zypper modifyrepo [upgrade builtin priority]"
sudo zypper mr -p 98 repo-debug repo-oss repo-source repo-update

# Set of repos needed for a base system.
echo ">> zypper addrepo [repos]"
zypper repos vndr-vlc      &>/dev/null || sudo zypper addrepo -f -p 97 "http://download.videolan.org/pub/vlc/SuSE/${OPENSUSE_DISTRO#openSUSE_}" vndr-vlc
zypper repos obs-termite   &>/dev/null || sudo zypper addrepo -f "obs://home:hurricanehernandez:termite" obs-termite
zypper repos obs-fs        &>/dev/null || sudo zypper addrepo -f "obs://filesystems" obs-fs
zypper repos obs-wireguard &>/dev/null || sudo zypper addrepo -f "obs://network:vpn:wireguard" obs-wireguard
zypper repos obs-hardware  &>/dev/null || sudo zypper addrepo -f "obs://hardware" obs-hardware
sudo zypper ref

# Set of packages we need for a base system.
# TODO: Make it possible to specify whether it's a workstation or server.

echo ">> zypper install [packages]"
packages=(
	# Basic cli tools necessary.
	"neovim" "tmux" "zsh" "git" "gcc" "go" "keychain" "figlet" "gpg2" "python3"
	"mosh" "rsync" "ranger" "alsa-utils" "weechat" "make" "exfat-utils"
	"fuse-exfat" "xfsprogs" "autoconf" "automake" "libtool"
	# Container-related packages.
	"skopeo" "umoci" "runc" "docker"
	# Basic graphics stack and environment.
	"i3" "i3lock" "i3status" "dmenu" "feh" "ImageMagick" "xorg-x11-server"
	"xf86-video-intel" "xf86-input-keyboard" "xf86-input-mouse" "compton"
	"xf86-input-libinput" "lightdm" "lightdm-gtk-greeter" "dina-bitmap-fonts"
	"xbacklight"
	# Graphical programs.
	"keepassxc" "firefox" "vlc" "termite" "redshift" "libreoffice" "zathura"
	# WireGuard
	"wireguard-kmp-default" "wireguard-tools"
	# Good-to-haves.
	"torbrowser-launcher" "tor" "sshfs"
	# Mutt and related packages.
	"neomutt" "zenity" "isync"
	# Android.
	"android-tools"
)
sudo zypper install "${packages[@]}"
