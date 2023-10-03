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

# Wrap start-up in a function, to make cleanup easier.
def __atstart__():
	import readline
	import rlcompleter

	# Steal the default completer for later wrapping.
	default_completer = rlcompleter.Completer(locals())

	# A custom tab-completer, which allows for tabs to be used as indentation.
	def my_completer(text, state):
		if text.strip() == "" and state == 0:
			return text + "\t"
		else:
			return default_completer.complete(text, state)

	# Bind the tab-completion to the completer, using the appropriate library.
	readline.set_completer(my_completer)
	if "libedit" in readline.__doc__:
		readline.parse_and_bind("bind ^I rl_complete")
	else:
		readline.parse_and_bind("tab: complete")

# XXX: This is currently broken.
# Run startup, and delete the reference to it, so as not to pollute the REPL.
#__atstart__()
#del __atstart__
