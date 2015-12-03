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

# Install options, modified by command-line flags.
PREFIX = os.path.expanduser("~")
CLOBBER = True
FRAGILE = False
HOOK_DIR = "hooks"

# Hook constants.
HOOK_BEFORE = "before"
HOOK_AFTER = "after"

# Install targets.
OPTIONS = {
	"fonts":   (YES, [".fonts/", ".fonts.conf.d/"]),
	"git":     (YES, [".gitconfig"]),
	"zsh":     (YES, [".profile", ".zsh/", ".zshrc"]),
	"python":  (YES, [".pythonrc.py"]),
	"vim":     (YES, [".vim/", ".vimrc"]),
	"tmux":    (YES, [".tmux.conf"]),
	"wget":    (YES, [".wgetrc"]),
	"termite": (NO,  [".config/termite/"]),
	"bin":     (YES, [".local/bin/"]),
	"i3":      (NO,  [".i3/"])
}


# Stdio helpers.

def _warn(*args, **kwargs):
	print("[!]", *args, **kwargs)

def _info(*args, **kwargs):
	print("[*]", *args, **kwargs)

def _ask(prompt, **kwargs):
	return input("[?] %s " % (prompt,), **kwargs) or ""


# File helpers.

def _exists(path):
	try:
		os.stat(path)
	except FileNotFoundError:
		return False
	return True

def _sanitise(path):
	path = os.path.join(path, "")
	path = os.path.dirname(path)
	return path

# Returns the last path component.
def _safe_basename(path):
	path = _sanitise(path)
	path = os.path.basename(path)
	return path

# Returns the path minus the last component.
def _safe_dirname(path):
	path = _sanitise(path)
	path = os.path.dirname(path)
	return path

# Makes the set of directories, ignoring permission issues.
def _makedirs(path, *args, **kwargs):
	if not _exists(path):
		os.makedirs(path, *args, **kwargs)

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


# Main install script and helpers.

def _run_hook(ctx, hook):
	# Generate the script path.
	script = os.path.join(HOOK_DIR, ctx, hook)

	# Ignore non-existant hooks.
	if not _exists(script):
		return 0

	# Something something shell out to os.path.join(ctx, hook).
	# You trust me, right? :P
	ret = subprocess.call([script])

	if ret != 0:
		_warn("%s hook for '%s' returned with non-zero error code: %d" % (ctx.title(), hook, ret))

	return ret

def _response_bool(response, default=True):
	if is_yes(response):
		return True
	elif is_no(response):
		return False

	return default

def _install(target, files):
	# Run before hook.
	if _run_hook(HOOK_BEFORE, target):
		return 1

	for _file in files:
		# Deal with leading directories in path.
		prefix = os.path.join(PREFIX, _safe_dirname(_file))
		_makedirs(prefix, exist_ok=True)

		# Copy the file to its new PREFIX.
		_copy(_file, prefix, clobber=CLOBBER)

	# Run after hook.
	return _run_hook(HOOK_AFTER, target)

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
		return 0

	# Make sure that the PREFIX path is real.
	_makedirs(PREFIX, exist_ok=True)

	# We want to return a non-zero error code in case of any error, but still
	# blindly blunder on installing orthogonal components.
	retval = 0

	# Actually install the buggers.
	for choice in chosen:
		# Print information to the user.
		_info("Installing '%s'." % (choice,))

		# Install the files.
		_, files = OPTIONS[choice]
		retval |= _install(choice, files)

		if FRAGILE and retval:
			_warn("Cowardly refusing to continue installation, because '%s' failed." % (choice,))
			return retval

	return retval

if __name__ == "__main__":
	def __atstart__():
		# Something, something scoping?
		global PREFIX
		global CLOBBER
		global FRAGILE
		global HOOK_DIR

		# Set up argument parser.
		parser = argparse.ArgumentParser()
		parser.add_argument("--prefix", dest="prefix", type=str, default=PREFIX)
		parser.add_argument("--hook-dir", dest="hook_dir", type=str, default=HOOK_DIR)
		parser.add_argument("-nc", "--no-clobber", dest="clobber", action="store_const", const=False, default=CLOBBER)
		parser.add_argument("-c", "--clobber", dest="clobber", action="store_const", const=True, default=CLOBBER)
		parser.add_argument("-nf", "--no-fragile", dest="fragile", action="store_const", const=False, default=FRAGILE)
		parser.add_argument("-f", "--fragile", dest="fragile", action="store_const", const=True, default=FRAGILE)

		# Get arguments.
		args = parser.parse_args()

		# Change options.
		PREFIX = os.path.expanduser(args.prefix)
		CLOBBER = args.clobber
		FRAGILE = args.fragile
		HOOK_DIR = args.hook_dir

	# Run wrapper and clean up.
	__atstart__()
	del __atstart__

	# XXX: Should I add a banner saying "read the code before you execute it"?

	# Run main program.
	retval = main()
	sys.exit(retval)
