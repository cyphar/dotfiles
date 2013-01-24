# profile - executed by the command interpreter on login shell

# run the .bashrc in the users home directory
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# ensure that no history is saved for root
if [ ${EUID} == 0 ]; then
	echo > $HISTFILE
	history -c
fi
