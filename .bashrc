# only if running interactively
if [[ -n $PS1 ]]; then

# Comment this line to allow the script to automatically decide whether to use colours
force_colour=yes

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
		PS1="\[\e[1;31m\]\h\[\e[m\]"
	else 
		PS1="\[\e[1;32m\]\u\[\e[m\]\[\e[0;32m\]@\h\[\e[m\]"
	fi
	
	PS1="$PS1:\[\e[1;34m\]\w\[\e[m\]\$ "
else
	if [ ${EUID} == 0 ]; then
		PS1="\h"
	else
		PS1="\u@\h"
       	fi
		PS1="$PS1:\w\$ " # keep it in this form in case of root-specific additions later
fi

unset colour_prompt force_colour

# Read aliases from ~/.bash_alias
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# Print a banner
if [ -n "`figlet -v`" ]; then
	figlet "<< `uname -s` >>" > .bashbanner # If figlet is installed, generate the banner, otherwise use the one in the git repos
fi
cat .bashbanner
echo "`uname -o` (`uname -sr`) `date`"

fi #interactive?
