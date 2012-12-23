#!/bin/sh

YES=y
NO=n

function option () {
	read -p "$2" OPTION
	case "$OPTION" in
		"Y"|"y"|"$YES")
			eval ${1}=$YES
			;;
		"N"|"n"|"$NO")
			eval ${1}=$NO
			;;
		*)
			# read -i doesn't seem to work, so do it manually
			eval ${1}=$3
			;;
	esac
}

echo "Choose what to install ($YES/$NO)." 1>&2
option "CLEANUP"	"Clean up old files [$YES]? "	$YES
option "VIMCONFIG"	"Install vim configs [$YES]? "	$YES
option "GITCONFIG"	"Install git configs [$NO]? "	$NO
option "BASHCONFIG"	"Install bash configs [$YES]? " $YES
option "GENSSH"		"Generate a new set of SSH keys [$NO]? " $NO

# clean up any old files
if [ $CLEANUP == $YES ]; then
	echo "*** Cleaning old files ***" 1>&2
	if [ $BASHCONFIG == $YES ]; then
		rm -f ~/.bashrc ~/.bash_alias ~/.profile ~/.bashbanner
		rm -f ~/.bash_profile ~/.bash_login # These stuff up the .profile script
	fi

	if [ $VIMCONFIG == $YES ]; then
		rm -rf ~/.vim/
		rm -f ~/.vimrc
	fi

	if [ $GITCONFIG == $YES ]; then
		rm -f ~/.gitconfig
	fi

	if [ $GENSSH == $YES ]; then
		rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub # Delete RSAv2 keys
		rm -f ~/.ssh/identity ~/.ssh/identity.pub # Delete RSAv1 keys
		rm -f ~/.ssh/id_dsa ~/.ssh/id_dsa.pub # Delete DSA keys
	fi
else
	echo "*** WARNING: Skipping cleanup (NOT RECCOMENDED) ***" 1>&2
fi

# install bash configs

if [ $BASHCONFIG == $YES ]; then
	echo "*** Installing bash config ***" 1>&2
	cp .bashrc ~/
	cp .bash_alias ~/
	cp .profile ~/
	cp .bashbanner ~/
else
	echo "*** Skipped bash config ***" 1>&2
fi

# install vim configs
if [ $VIMCONFIG == $YES ]; then
	echo "*** Installing vim configs ***" 1>&2
	cp .vimrc ~/
	cp -r .vim ~/
else
	echo "*** Skipped vim configs ***" 1>&2
fi

# install gitconfig
if [ $GITCONFIG == $YES ]; then
	echo "*** Installing gitconfig ***" 1>&2
	cp .gitconfig ~/
else
	echo "*** Skipped gitconfig ***" 2>&1
fi

if [ $GENSSH == $YES ]; then
	echo "*** Generating ssh keys ***" 2>&1
	option "SSHCOMMENT" "Do you want to add your own comment to the key [$NO]?" $NO
	if [ $SSHCOMMENT == $YES ]; then
		read -p "Enter comment: " COMMENT
		ssh-keygen -t rsa -b 4096 -C $COMMENT
	else
		ssh-keygen -t rsa -b 4096
	fi
else 
	echo "*** Skipped ssh keys ***" 2>&1
fi
