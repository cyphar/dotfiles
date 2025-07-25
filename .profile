#!/bin/sh
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2023 Aleksa Sarai <cyphar@cyphar.com>
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

# profile -- executed by any POSIX shell on login

# run the .zshrc in the user's home directory
if [ -n "${ZSH_VERSION}" ]; then
	if [ -f "${HOME}/.zshrc" ]; then
		. "${HOME}/.zshrc"
	fi
fi

# enable fcitx support
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
