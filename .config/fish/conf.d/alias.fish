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

# Some weird distros don't symlink vi -> vim (-> nvim). This is wrong. Also add
# an alias for "v" just for my own sanity.
alias v "vi"
alias vi "vim"
alias vim "nvim"

# ls shortcuts and with colours.
alias ls "ls --color=auto"
alias sl "ls"
alias ll "ls -alF"
alias la "ls -A"
alias l "ls -CF"

# grep colours.
alias grep "grep --color=auto"
alias fgrep "fgrep --color=auto"
alias egrep "egrep --color=auto"

# Make Valgrind ... work.
alias valgrind "valgrind --leak-check=full --trace-children=yes"
alias vgs "valgrind --read-ver-info=yes"
alias vg "valgrind"

# NOTE: For `goc` and `prox/unprox` please see ~/.config/fish/functions/*.fish

# Mess around with pico and nano.
function nano
	echo "Seriously? Why don't you just use notepad.exe, MS Paint or Emacs?"
	return 1
end

alias pico "nano"

# Add `time` to `make`, so that we get automagical build script timing
# information, even if you forget to add `time`.
abbr -a -g make "time make"

# For OBS.
alias iosc "osc -A https://api.suse.de"
alias eosc "osc -A https://api.opensuse.org"

# Nice^[citation needed] relative jumps.
alias ..2 "cd ../.."
alias ..3 "cd ../../.."
alias ..4 "cd ../../../.."
alias ..5 "cd ../../../../.."

