# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
# Copyright (C) 2021 Chris Carter <chris@gibsonsec.org>
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

function goc -d "Make cross-compiling Go easier" -a "arch"
	echo env GOARCH="$arch" go $argv[2..-1]
end

# Behold! The miracles of abbreviations!
# You can also use alias if you're feeling old school.
abbr -a -g go64 "goc amd64"
abbr -a -g go32 "goc 386"
abbr -a -g goarm "goc arm"

