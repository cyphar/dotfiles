#!/usr/bin/env python3
# dotfiles: a collection of configuration files
# Copyright (C) 2015 Cyphar

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

import os
import stat
import shutil
import argparse

# Default "yes" and "no" shortcuts.
YES = "yes"
NO = "no"

# Lambdas for checking input.
is_yes = lambda s: s.lower() in {YES, "y", "yes", "true"}
is_no  = lambda s: s.lower() in {NO, "n", "no", "false"}

# Install options, modified by command-line flags.
PREFIX = os.path.expanduser("~")
CLOBBER = True

# Install targets.
OPTIONS = {
	"fonts":  (YES, [".fonts/", ".fonts.conf.d/"]),
	"git":    (YES, [".gitconfig"]),
	"moss":   (NO,  [".mossrc"]),
	"zsh":    (YES, [".profile", ".zsh/", ".zshrc"]),
	"python": (YES, [".pythonrc.py"]),
	"vim":    (YES, [".vim/", ".vimrc"]),
	"tmux":   (YES, [".tmux.conf"]),
	"wget":   (YES, [".wgetrc"]),
	"bin":    (YES, ["bin/"]),
}


# Stdio helpers.

def _warn(*args, **kwargs):
	print("[!]", *args, **kwargs)

def _info(*args, **kwargs):
	print("[*]", *args, **kwargs)
	pass

def _ask(prompt, **kwargs):
	return input("[?] %s " % (prompt,), **kwargs) or ""


# File helpers.

def _exists(path):
	try:
		os.stat(path)
	except FileNotFoundError:
		return False
	return True

def _safe_basename(path):
	path = os.path.join(path, "")
	path = os.path.dirname(path)
	path = os.path.basename(path)
	return path

def _copy(source, target, clobber=True):
	"""
	Copies source (regardless of inode type) to target.
	Where target is the directory the source will be copied to.
	      source is the path of the thing to be copied.
	"""

	# Stat the source.
	st_src = os.stat(source)

	# Generate target path.
	basename = _safe_basename(source)
	target_path = os.path.join(target, basename)

	# Check if we are about to clobber the destination.
	if _exists(target_path) and not clobber:
		_warn("Target path '%s' already exists! Skipping." % (target_path,))

	# Directories are a magic case.
	if stat.S_ISDIR(st_src.st_mode):
		# Make an empty slot for the children.
		if not _exists(target_path):
			os.mkdir(target_path)

		# Recursively copy all of the files.
		for child in os.listdir(source):
			child = os.path.join(source, child)
			_copy(child, target_path)

	# Regular files (and symlinks).
	else:
		fsrc = open(source, "rb")
		fdst = open(target_path, "wb")

		shutil.copyfileobj(fsrc, fdst)
		shutil.copymode(source, target_path)


# Main install script and helper.

def _response_bool(response, default=True):
	if is_yes(response):
		return True
	elif is_no(response):
		return False

	return default

def _install(files):
	for _file in files:
		# Copy the file to its new PREFIX.
		_copy(_file, PREFIX, clobber=CLOBBER)

def main():
	# Chosen list.
	chosen = []

	# Ask user which targets they'd like.
	for option, value in OPTIONS.items():
		# Unpack option.
		default, files = value

		# Ask if they wish to install the program.
		response = _ask("Do you wish to install '%s' [%s]?" % (option, default))
		install = _response_bool(response)

		# Add to the chosen list if it works.
		if install:
			chosen.append(option)

	# Nothing chosen to be installed.
	if not chosen:
		return

	# Make sure that the PREFIX path is real.
	os.makedirs(PREFIX, exist_ok=True)

	# Actually install the buggers.
	for choice in chosen:
		# Print information to the user.
		_info("Installing '%s'." % (choice,))

		# Install the files.
		_, files = OPTIONS[choice]
		_install(files)

if __name__ == "__main__":
	def __atstart__():
		# Something, something scoping?
		global CLOBBER
		global PREFIX

		# Set up argument parser.
		parser = argparse.ArgumentParser()
		parser.add_argument("--prefix", dest="prefix", type=str, default="~")
		parser.add_argument("-nc", "--no-clobber", dest="clobber", action="store_const", const=False, default=True)
		parser.add_argument("-c", "--clobber", dest="clobber", action="store_const", const=True, default=True)

		# Get arguments.
		args = parser.parse_args()

		# Change options.
		PREFIX = os.path.expanduser(args.prefix)
		CLOBBER = args.clobber

	# Run wrapper and clean up.
	__atstart__()
	del __atstart__

	# Run main program.
	main()