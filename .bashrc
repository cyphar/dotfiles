# only if running interactively
if [ -z "$PS1" -o -v "$PS1" ]; then return; fi

export EDITOR="vim"

# Comment this line to allow the script to automatically decide whether to use colours
force_colour=yes

# Commend this line in order to disable the colour/smiley feedback
feedback=yes

stty columns 1000
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
		PS1="$PS1\`if [ \$? = 0 ]; then echo -e ''; else echo -e '\e[01;31m'; fi\` \\$\[\e[m\] "
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

# Read aliases from ~/.bash_alias
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# Print a banner
if [ -n "`figlet -v`" ]; then
	figlet "<< `uname -s` >>" > ~/.bash_banner # If figlet is installed, generate the banner, otherwise use the one in the git repos
fi

# eradicate all history
if [ ${EUID} = 0 ]; then
	echo > $HISTFILE
	history -c
fi

cat ~/.bash_banner
echo "`uname -o` (`uname -sr`) `date`"
