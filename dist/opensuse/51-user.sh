#!/bin/bash
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

set -Eeuo pipefail

# Set our shell to be zsh.
sudo usermod -s/bin/zsh "$USER"

# Set up our ~/.local/src gopath.
if [[ -e "$HOME/.local/src" && ! -L "$HOME/.local/src" ]]
then
	echo "Skipping ~/.local/src setup (already exists)."
else
	ln -sfT "../src" "$HOME/.local/src"
fi

# Add ourselves to the docker group, if it exists (we no longer install Docker
# by default).
sudo usermod -a -G docker "$USER" || :
