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

# Honestly I have no idea how Fish handles CJK. Let's gamble it's good.
set -xg GTK_IM_MODULE ibus
set -xg XMODIFIERS "@im=ibus"
set -xg QT_IM_MODULE ibus

# Only set up if running interactively
if not status --is-interactive
	exit 0
end

# If the current shell is not running in tmux, start/attach to a tmux session.
if command -q tmux; and not set -q TMUX
	# The default name for the tmux session is the superior `cyphar/fish`.
	set -q TMUX_SESSION; or set -l TMUX_SESSION "cyphar/fish"

	# Start the server in case it doesn't exist.
	tmux start-server

	if not tmux has-session -t "$TMUX_SESSION" ^/dev/null
		tmux new-session -t "$TMUX_SESSION" -d -c "$HOME"
	end

	# Switch to tmux session.
	# You can set $TMUX to any value to stop this from happening.
	exec tmux attach-session -t "$TMUX_SESSION"
end

# Things not required because this isn't the 80s dammit, my shell has
#   reasonable defaults:
# - ~/.zsh/* -> Fish sources ~/.config/fish/conf.d/*.fish automatically
# - `+histignoredups` and `+no_sharehistory` are... just reasonable defaults
# - `+completealiases` - why is that optional?
# - compinit -- auto complete is built in and colourful.
# - ~/.profile ??? why separate bro
# - `..` is a builtin as is `+autocd`
# - I just ignored the entire `~/.zsh/input` file because I'm pretty sure any
#   software made after Hackers (1995) has those as defaults...
# Your prompt will forever be embedded in my nightmares.
# All things considered ... probably don't set Fish to your login shell.

if status --is-login
	umask 022

	add_to_path ~/.local/bin

	set -xg EDITOR "nvim"
	set -xg PAGER "less"
	set -xg TERMINAL "alacritty"

	# Make go ... work.
	set -xg GOPATH "$HOME/go"
	set -xg CDPATH . "$GOPATH/src"

	# Make Python load `~/.pythonrc.py`
	set -xg PYTHONSTARTUP "$HOME/.pythonrc.py"

	# Made TERM work nicer. This is also changed by .tmux.conf, but we might as
	# well ensure it's correct here.
	set -xg TERM screen-256color

	# Make sure "git commit" will actually show you pinentry...
	set -xg GPG_TTY (tty)

	if test -f ~/.cargo/env
		source ~/.cargo/env
	end

	if command -q keychain
		eval (keychain --eval --agents ssh -Q --quiet --nogui "$HOME/.ssh/id_ed25519")
	end
end
