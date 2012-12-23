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
	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\e[01;31m\]\h\[\e[m\]'; else echo '\[\e[01;32m\]\u@\h\[\e[m\]'; fi):\[\e[1;34m\]\w\[\e[m\]\$ "
else
	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\h'; else echo '\u@\h'; fi):\w\$ " # keep it in this form in case of root-specific additions later
fi

unset colour_prompt force_colour

# Read aliases from ~/.bash_alias
if [ -f ~/.bash_alias ]; then
    . ~/.bash_alias
fi

# Print a banner
cat ./.bashbanner
echo "`uname -o` (`uname -s` `uname -r`) on `date`"


fi #interactive?
