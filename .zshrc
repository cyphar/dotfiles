#!/bin/zsh
# This is free and unencumbered software released into the public domain.

# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

# Only set up if running interactively.
[[ -t 0 ]] || exit 0

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
export EDITOR="vim"
export PAGER="less"

# Make go ... work.
export GOPATH="${HOME}"

# Make python load `.pythonrc.py`
export PYTHONSTARTUP="${HOME}/.pythonrc.py"

# Made TERM work nicer.
export TERM="xterm-256color"

# Make the history usable.
setopt histignoredups sharehistory

# Set up keychain.
if (keychain --version 2>/dev/null); then
	eval $(keychain --eval --agents ssh -Q --quiet --nogui "${HOME}/.ssh/id_rsa")
fi
