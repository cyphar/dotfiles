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

# Enable graphics.
sudo systemctl enable display-manager
sudo systemctl set-default graphical

# Set lightdm as the default displaymanager.
sudo sed -i 's|^DISPLAYMANAGER=.*|DISPLAYMANAGER="lightdm"|g' /etc/sysconfig/displaymanager

# Set up our wallpaper. By default we swap from the openSUSE one, but to avoid
# copyright problems I don't include any given wallpaper here.
sudo mkdir -p /usr/share/wallpapers
sudo sed -i 's|^#?background=.*|background=/usr/share/wallpapers/default.jpg' /etc/lightdm/lightdm-gtk-greeter.conf
