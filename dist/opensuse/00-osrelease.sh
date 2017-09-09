#!/bin/bash
# dotfiles: collection of my personal dotfiles [code]
# Copyright (C) 2017 Aleksa Sarai <cyphar@cyphar.com>
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

# TODO: Support more than just tumbleweed.
OPENSUSE_DISTRO="openSUSE_Tumbleweed"
[[ "$OS_NAME" == "openSUSE Tumbleweed" ]] || bail "unsupported opensuse distro: $OS_NAME"