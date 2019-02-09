#!/bin/bash
# dotfiles: collection of my personal dotfiles [code]
# Copyright (C) 2017-2019 Aleksa Sarai <cyphar@cyphar.com>
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

# Everything is rooted at dist/.
DIST_ROOT="$(readlink -f "$(dirname "$BASH_SOURCE")")"

# Helper functions to make the messages a bit prettier.
function info() {
	echo "[*]" "$@" >&2
}
function bail() {
	echo "[!]" "$@" >&2
	exit 1
}

# Get the current OS information.
source /etc/os-release

# Check that we support the distribution.
[ -d "$DIST_ROOT/$ID" ] || bail "Unsupported distribution: $ID."

# Export the information from os-release.
export OS_NAME="$NAME" OS_ID="$ID" OS_ID_LIKE="$ID_LIKE" \
	OS_VERSION_ID="$VERSION_ID" OS_PRETTY_NAME="$OS_PRETTY_NAME"

# Run all of the respective hooks.
info "Installing for distribution $OS_ID ($OS_NAME)."
for script in "$DIST_ROOT/$ID/"*.sh
do
	info "Running $(basename "$script")."
	source "$script"
done
