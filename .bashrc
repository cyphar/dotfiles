#!/bin/sh
# dotfiles: a collection of configuration files
# Copyright (C) 2013, 2014 Cyphar

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# 1. The above copyright notice and this permission notice shall be included in
#    all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# only if running interactively
if [ -z "$PS1" -o -v "$PS1" ]; then return; fi

# Set aliases from $HOME/.bashalias
if [ -f $HOME/.bashalias ]; then
    . $HOME/.bashalias
fi

# Configure prompt from $HOME/.bashalias
if [ -f $HOME/.bashprompt ]; then
    . $HOME/.bashprompt
fi

# Eradicate all history
if [ ${EUID} = 0 ]; then
	echo > $HISTFILE
	history -c
fi

# Exports
export PATH="$PATH:$HOME/bin"
export EDITOR="vim"
export PAGER="less"

# Go Exports
export GOPATH="$HOME"

# XTERM transparency
[ -n "$XTERM_VERSION" ] && transset-df -a 0.85 >/dev/null

# Set the banner
if [ -n "$(figlet -v)" ]; then
	# If figlet is installed, generate the banner, otherwise use the one in the git repos
	figlet "<< $(uname -s) >>" > $HOME/.bashbanner
fi

# Print out the banner.
cat "$HOME/.bashbanner"
echo "$(uname -o) ($(uname -sr)) $(date)"
