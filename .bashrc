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

##################
# Welcome Screen #
##################

if [ -f $HOME/.bashbanner ]; then
	. $HOME/.bashbanner
fi

###########
# Imports #
###########

# Set aliases from $HOME/.bashalias
if [ -f $HOME/.bashalias ]; then
    . $HOME/.bashalias
fi

# Configure prompt from $HOME/.bashalias
if [ -f $HOME/.bashprompt ]; then
    . $HOME/.bashprompt
fi

###########
# Exports #
###########

export PATH="$PATH:$HOME/bin"
export EDITOR="vim"
export PAGER="less"

# Make go ... work
export GOPATH="$HOME"

###################
# History actions #
###################

# Eradicate all history
if [ ${EUID} = 0 ]; then
	echo > $HISTFILE
	history -c
fi

# ensure that no history is saved for root
if [ ${EUID} == 0 ]; then
	echo > $HISTFILE
	history -c
	unset HISTFILE
fi

################
# Daemon setup #
################

# Set up keychain
if keychain --version 2>/dev/null; then
	eval $(keychain --eval --agents ssh -Q --quiet --nogui "$HOME/.ssh/id_rsa")
fi
