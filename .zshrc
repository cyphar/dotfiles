#!/bin/zsh
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
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

# Only set up if running interactively.
[[ -t 0 ]] || exit 0

if (tmux -V &>/dev/null); then
	# If the current shell is not running in tmux, start/attach to a tmux session.
	if (( $+TMUX == 0 )); then
		# The default name for the tmux session is `cyphar/zsh`.
		local __tmux_session="${TMUX_SESSION:-cyphar/zsh}"

		# Start the server in case it doesn't exist.
		tmux start-server

		# Create the session if it doesn't exist.
		if ! (tmux has-session -t "${__tmux_session}" &>/dev/null); then
			tmux new-session -t "${__tmux_session}" -d -c "$HOME"
		fi

		# Switch to tmux session.
		# You can set $TMUX to any value to stop this from happening.
		exec tmux attach-session -t "${__tmux_session}"
	fi
fi

# Load completion.
autoload -U compinit
compinit

# Load all scripts in ~/.zsh.
if [[ -d "${HOME}/.zsh" ]]; then
	for file in $(find "${HOME}/.zsh" -type f); do
		source "${file}"
	done
fi

# Export the standard stuff.
export PATH="${PATH}:${HOME}/.local/bin"
export EDITOR="nvim"
export PAGER="less"
export TERMINAL="termite"

# Make go ... work. This is inspired by how runc0m handles things.
export GOPATH="${HOME}/.local"
export CDPATH=".:${GOPATH}/src"

# Make python load `.pythonrc.py`
export PYTHONSTARTUP="${HOME}/.pythonrc.py"

# Made TERM work nicer.
# This is also changed by .tmux.conf, but we might as well ensure it's correct here.
export TERM="screen-256color"

# Make the history usable.
setopt histignoredups no_sharehistory

# Set up keychain.
if (keychain --version 2>/dev/null); then
	eval $(keychain --eval --agents ssh -Q --quiet --nogui "${HOME}/.ssh/id_ed25519")
fi
