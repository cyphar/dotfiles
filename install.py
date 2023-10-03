#!/usr/bin/env python3
# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2023 Aleksa Sarai <cyphar@cyphar.com>
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

import os
import sys
import stat
import shutil
import argparse
import subprocess

# Default "yes" and "no" shortcuts.
YES = "yes"
NO = "no"

# Lambdas for checking input.
is_yes = lambda s: s.lower() in {YES, "y", "yes", "true"}
is_no  = lambda s: s.lower() in {NO, "n", "no", "false"}

# Hook constants.
HOOK_BEFORE = "before"
HOOK_AFTER = "after"

# Install targets.
OPTIONS = {
	"alacritty": (YES, [".config/alacritty/"]),
	"bin":       (YES, [".local/bin/"]),
	"dunst":     (YES, [".config/dunst/"]),
	"fonts":     (YES, [".config/fontconfig/"]),
	"git":       (YES, [".gitconfig"]),
	"i3":        (YES, [".config/i3/", ".config/i3status/"]),
	"keepassxc": (YES, [".config/keepassxc/"]),
	"mbsync":    (YES, [".mbsyncrc-personal", ".mbsyncrc-suse"]),
	"mpv":       (YES, [".config/mpv/"]),
	"mutt":      (YES, [".mutt/"]),
	"neovim":    (YES, [".config/nvim/"]),
	"notmuch":   (YES, [".notmuch-config"]),
	"python":    (YES, [".pythonrc.py"]),
	"redshift":  (YES, [".config/redshift.conf"]),
	"ssh":       (YES, [".ssh/config"]),
	"tmux":      (YES, [".tmux.conf"]),
	"wget":      (YES, [".wgetrc"]),
	"zsh":       (YES, [".profile", ".zsh/", ".zshrc"]),
}

# Stdio helpers.

def warn_user(*args, **kwargs):
	print("[!]", *args, **kwargs)

def info_user(*args, **kwargs):
	print("[*]", *args, **kwargs)

def ask_user(prompt, **kwargs):
	return input("[?] %s " % (prompt,), **kwargs) or ""


# File helpers.

def path_exists(path):
	try:
		os.stat(path)
	except FileNotFoundError:
		return False
	return True

def path_sanitise(path):
	path = os.path.join(path, "")
	path = os.path.dirname(path)
	return path

# Returns the last path component.
def safe_basename(path):
	path = path_sanitise(path)
	path = os.path.basename(path)
	return path

# Returns the path minus the last component.
def safe_dirname(path):
	path = path_sanitise(path)
	path = os.path.dirname(path)
	return path

# Makes the set of directories, ignoring permission issues.
def makedirs(path, *args, **kwargs):
	if not path_exists(path):
		os.makedirs(path, *args, **kwargs)

def path_copy(source, target, clobber=True):
	"""
	Copies source (regardless of inode type) to target.
	Where target is the directory the source will be copied to.
	      source is the path of the thing to be copied.
	"""

	# Stat the source.
	st_src = os.stat(source)

	# Generate target path.
	basename = safe_basename(source)
	target_path = os.path.join(target, basename)

	# Check if we are about to clobber the destination.
	if path_exists(target_path) and not clobber:
		warn_user("Target path '%s' already exists! Skipping." % (target_path,))

	# Directories are a magic case.
	if stat.S_ISDIR(st_src.st_mode):
		# Make an empty slot for the children.
		if not path_exists(target_path):
			os.mkdir(target_path)

		# Recursively copy all of the files.
		for child in os.listdir(source):
			child = os.path.join(source, child)
			path_copy(child, target_path)

	# Regular files (and symlinks).
	else:
		fsrc = open(source, "rb")
		fdst = open(target_path, "wb")

		shutil.copyfileobj(fsrc, fdst)
		shutil.copymode(source, target_path)


# Main install script and helpers.

def response_bool(response, default=True):
	if is_yes(response):
		return True
	elif is_no(response):
		return False
	elif not response:
		return default

def run_script(script):
	# Ignore non-existant scripts.
	if not path_exists(script):
		return 0
	return subprocess.call([script])

def run_hook(config, ctx, hook):
	script = os.path.join(config.hook_dir, ctx, hook)
	ret = run_script(script)
	if ret != 0:
		warn_user("%s hook for '%s' returned with non-zero error code: %d" % (ctx.title(), hook, ret))
	return ret

def do_install(config, target, files):
	if run_hook(config, HOOK_BEFORE, target):
		return 1

	for _file in files:
		# Deal with leading directories in path.
		prefix = os.path.join(config.prefix, safe_dirname(_file))
		makedirs(prefix, exist_ok=True)

		# Copy the file to its new prefix.
		path_copy(_file, prefix, clobber=config.clobber)

	return run_hook(config, HOOK_AFTER, target)

def main(config):
	if config.list_groups:
		for group in OPTIONS:
			print(group)
		return 0

	chosen = config.groups
	if not chosen:
		# Ask user which targets they'd like.
		for option, value in OPTIONS.items():
			# Unpack option.
			default, files = value

			# Ask if they wish to install the program.
			install = None
			while install is None:
				response = ask_user("Do you wish to install '%s' [%s]?" % (option, default))
				install = response_bool(response, default=response_bool(default))

			# Add to the chosen list if it works.
			if install:
				chosen.append(option)

	# Nothing chosen to be installed.
	if not chosen:
		return 0

	# Make sure that the prefix path is real.
	makedirs(config.prefix, exist_ok=True)

	# We want to return a non-zero error code in case of any error, but still
	# blindly blunder on installing orthogonal components.
	retval = 0

	# Actually install the buggers.
	for choice in chosen:
		# Print information to the user.
		info_user("Installing '%s'." % (choice,))

		# Install the files.
		_, files = OPTIONS[choice]
		retval |= do_install(config, choice, files)

		if config.fragile and retval:
			warn_user("Cowardly refusing to continue installation, because '%s' failed." % (choice,))
			return retval

	# Run setup scripts for the distribution.
	install_dist = None
	while install_dist is None:
		default = NO
		response = ask_user("Do you wish to run distribution-specific scripts [%s]?" % (default,))
		install_dist = response_bool(response, default=response_bool(default))
	if install_dist:
		info_user("Executing distribution scripts.")
		retval |= run_script("dist/install.sh")

	# All done!
	return retval

if __name__ == "__main__":
	def __atstart__():
		# Set up argument parser.
		parser = argparse.ArgumentParser()
		parser.add_argument("--prefix", dest="prefix", type=str, default=os.path.expanduser("~"))
		parser.add_argument("--hook-dir", dest="hook_dir", type=str, default="hooks")
		# Boolean setting for clobber.
		parser.add_argument("-nc", "--no-clobber", dest="clobber", action="store_const", const=False, default=True)
		parser.add_argument("-c", "--clobber", dest="clobber", action="store_const", const=True, default=True)
		# Boolean setting for fragile.
		parser.add_argument("-nf", "--no-fragile", dest="fragile", action="store_const", const=False, default=False)
		parser.add_argument("-f", "--fragile", dest="fragile", action="store_const", const=True, default=False)
		# Control which groups to install?
		parser.add_argument("--list-groups", dest="list_groups", action="store_const", const=True, default=False)
		parser.add_argument("groups", nargs='*', default=[], help="The set of groups to install.")

		# Get arguments.
		args = parser.parse_args()
		# Fix up options.
		args.prefix = os.path.expanduser(args.prefix)

		# Run main program.
		sys.exit(main(args))
	__atstart__()
