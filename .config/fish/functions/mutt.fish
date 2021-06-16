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

function _mutt_wrapper -w "neomutt" -a "BOX"
	mkdir -p "$HOME/mail/$BOX"
	mbsync-helper -c "$HOME/.mbsyncrc-$BOX"; or true
	neumutt -F "$HOME/.mutt/muttrc-$BOX" $argv[2..-1]
	kill -9 (cat "$HOME/.mbsyncrc-$BOX.lock")
end

alias pmutt "_mutt_wrapper personal"
alias smutt "_mutt_wrapper suse"
