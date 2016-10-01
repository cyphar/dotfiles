#!/bin/zsh
# dotfiles: collection of my personal dotfiles [code]
# Copyright (C) 2012-2016 Aleksa Sarai <cyphar@cyphar.com>
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

# Output help page.
function _help() {
cat <<EOH
usage: lockmyi3 [-h] [-p <size=20>] [options]...

Locks your screen with i3lock, using a pixelated version of the current screen
as the background. The semantics of the "current screen" are borrowed from
ImageMagick's 'import -screen -window root' options.

Options:
  -p <size=20> -- Set the the size of each blocky pixel to <size> (in pixels).
  options      -- Options that are passed through to i3lock.
EOH
}

# Helper to calculate simple expressions.
function _calc() {
	bc -q <<<"$1"
}

# Get the options.
local __block_size=20
while getopts "p:h" __opt; do
	case "$__opt" in
		(p)
			__block_size="${OPTARG}"
			;;
		(h)
			_help
			exit 0;;
	esac
done

# Get pass-through options.
shift $(_calc "${OPTIND}-1")

# Gets the (width, height) of the screen.
read __screen_x __screen_y <<<$(xrandr -q | awk '
# xrandr tells us screen sizes.
$1 == "Screen" {
	# Line is of the form:
	#   Screen 0: minimum 8 x 8, current 3840 x 1080, maximum 32767 x 32767
	for(i = 1; i <= NF && $i != "current"; i++)
		;

	# We did not find "current".
	if($i != "current")
		exit 1;

	# Output the dimensions (there may be a trailing comma).
	print $(i+1), $(i+3);
	exit;
}' | tr -d ,)

# Calculate the "reduced" height and width for the down-scaling.
local __reduced_x=$(_calc "${__screen_x}/${__block_size}")
local __reduced_y=$(_calc "${__screen_y}/${__block_size}")

# Actually do the locking (generate the image without temporary files to not
# clutter the filesystem). Since `convert -scale` doesn't do blurring, scaling
# down and then back up is an efficient method of producing a pixelated image.
i3lock $* -i \
	<(import -screen -window root -silent png:- | \
	  convert png:- \
	          -scale '!'"${__reduced_x}x${__reduced_y}" \
	          -scale '!'"${__screen_x}x${__screen_y}" \
	          png:-)
