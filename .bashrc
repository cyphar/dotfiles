# dotfiles: a collection of configuration files
# Copyright (c) 2013 Cyphar

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

export EDITOR="vim"

# Comment this line to allow the script to automatically decide whether to use colours
force_colour=yes

# Commend this line in order to disable the colour/smiley feedback
feedback=yes

if [ "$TERM" = "xterm-color" ]; then
	colour_prompt=yes
fi

if [ -n "$force_colour" ]; then
	if [ -x /usr/bin/tput ] && [ tput setaf 1 >&/dev/null ]; then
		# Terminal has colour support
		colour_prompt=yes
	else
		# Terminal has not colour support, or doesn't "advertise" it
		colour_prompt=
	fi
fi

if [ "$colour_prompt" = yes -o "$force_colour" = yes ]; then
	if [ ${EUID} == 0 ]; then
		PS1="\[\e[1;31m\]\h\[\e[m\] "
	else
		PS1="\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h\[\e[m\] "
	fi

	PS1="$PS1\[\e[1;34m\]\W\[\e[m\]"

	if [ "$feedback" == yes ]; then
		PS1="$PS1 \`if [ \$? != 0 ]; then echo -e '\e[01;31m'; fi\`\\$\[\e[m\] "
	else
		PS1="$PS1 \\$ "
	fi
else
	if [ ${EUID} == 0 ]; then
		PS1="\h "
	else
		PS1="\u@\h "
       	fi

	PS1="$PS1\W"

	if [ "$feedback" == yes ]; then
		PS1="$PS1 \`if [ \$? = 0 ]; then echo -e ':)'; else echo -e ':('; fi\` \\$ " # keep it in this form in case of root-specific additions later
	else
		PS1="$PS1 \\$ "
	fi
fi

unset colour_prompt force_colour feedback

# Read aliases from $HOME/.bashalias
if [ -f $HOME/.bashalias ]; then
    . $HOME/.bashalias
fi

# Print a banner
if [ -n "`figlet -v`" ]; then
	figlet "<< `uname -s` >>" > $HOME/.bash_banner # If figlet is installed, generate the banner, otherwise use the one in the git repos
fi

# eradicate all history
if [ ${EUID} = 0 ]; then
	echo > $HISTFILE
	history -c
fi

# XTERM transparency
[ -n "$XTERM_VERSION" ] && transset-df -a 0.85 >/dev/null

# Print out the banner.
cat $HOME/.bashbanner
echo "`uname -o` (`uname -sr`) `date`"
