# dotfiles: collection of my personal dotfiles
# Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
# Copyright (C) 2021 Chris Carter <chris@gibsonsec.org>
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

function __find_git -d "Search up the directory tree to find the '.git' folder" -a "current"
	while test "$current" != "/"
		if test -d "$current/.git"
			echo "$current/.git"
			return 0
		end

		set current (dirname -- "$current")
	end

	# Check for `/.git`
	if test -d "$current/.git"
		echo "$current/.git"
		return 0
	end

	return 1
end

function __get_branch -d "Get the current branch ref from '.git/HEAD' and '.git/refs/heads'" -a "gitdir"
	if grep -qv '^ref: refs/heads/.*$' -- "$gitdir/HEAD"
		# Detached state -- no branch name.
		return 1
	end

	# Get the ref path
	set -l refbranch (cut -d' ' -f2 -- "$gitdir/HEAD")

	# Yield the actual branch name from the refbranch.
	echo (string replace -r '^refs/heads/' '' "$refbranch")
	return 0
end

function __get_short_ref -d "Get short commit hash." -a "gitdir"
	set -l refhash ""

	# Deteached state -- ref is in 'ref'.
	if not __get_branch "$gitdir" >/dev/null
		set refhash (cat "$gitdir/HEAD")
	else
		# Get the ref path.
		set -l refbranch (cut -d' ' -f2 -- "$gitdir/HEAD")

		# Check that the refbranch exists
		if not test -f "$gitdir/$refbranch"
			# If not, we might be on a commit in a packed ref.
			# Fallback to `git` in this case -- we can't do better.
			set refhash (git rev-parse --verify HEAD)

			# We don't have a commit.
			if test $status -ne 0
				return 1
			end
		else
			# Get the commit hash from the ref path.
			set refhash (cat "$gitdir/$refbranch")
		end
	end

	# Shorten the ref to 12 characters. Why 12?
	# Because that's what the kernel tell us is good.
	# ~~ In Linus we trust. ~~
	echo (string sub -e 12 "$refhash")
	return 0
end

function __git_info -d "Git branch and ref information."
	# Everything is calculated inside this shell script (no calls to `git` are
	# made). This is because on large projects (like, say, the kernel) git can
	# take >1 minute to figure out what branch and ref HEAD is pointing to. The
	# filesystem is faster. However, we have to fall back in *one* case, when
	# we are sitting on a packed ref or a repo which was recently gc'd -- in
	# that case `git` is faster and easier.

	# Most shells (Fish not included) like to be clever with symlinks. This
	# breaks things like symlinks into subdirectories of git repositories
	# (because `pwd` lies to you). Fish however doesn't need to be magical.
	set -l real_pwd (pwd -P)

	if __find_git "$real_pwd" >/dev/null ^/dev/null
		set -l gitdir (__find_git "$real_pwd")

		# Figure out if in detached state.
		set -l refinfo
		if __get_branch "$gitdir" >/dev/null
			set refinfo (set_color -o magenta)(__get_branch "$gitdir")(set_color normal)
		else
			set refinfo (set_color -o red)'{detached}'(set_color normal)
		end

		# Figure out short ref.
		set -l refhash
		if __get_short_ref "$gitdir" >/dev/null
			set refhash (set_color magenta)(__get_short_ref "$gitdir")(set_color normal)
		else
			set refhash (set_color magenta)000000000000(set_color normal)
		end

		echo " git:($refinfo:$refhash)"
	end
end

function __find_hg -a "current"
	# Hot path: check that there isn't a parent .hg/ directory.
	# We don't implement parsing (I don't clone big hg project often enough to
	# care).
	while test "$current" != "/"
		if test -d "$current/.hg"
			echo "$current/.hg"
			return 0
		end

		set current (dirname -- "$current")
	end

	# Check for `/.hg`
	if test -d "$current/.hg"
		echo "$current/.hg"
		return 0
	end

	return 1
end

function __hg_info -d "Mercurial branch information."
	# Most shells (Fish not included) like to be clever with symlinks. This
	# breaks things like symlinks into subdirectories of Mercurial repositories
	# (because `pwd` lies to you). Fish however doesn't need to be magical.
	set -l real_pwd (pwd -P)

	if __find_hg "$real_pwd" >/dev/null ^/dev/null; and hg status >/dev/null ^/dev/null
		# TODO: Switch to reading (pwd)/.hg directly to avoid Python overhead.
		set -l refbranch (hg branch)
		set -l refhash (hg id | cut -d' ' -f1)

		echo " hg:"(set_color -o magenta)"$refbranch"(set_color normal):(set_color magenta)"$refhash"(set_color normal)
	end
end

function __nice_path -d "Get the last part of the given path, with tilde replacement." -a "current_path"
	if test "$current_path" = "$HOME"
		set current_path "~"
	else
		set current_path (basename "$current_path")
	end

	echo "$current_path"
end

function __ret_prompt -a "exit_code"
	set -l prompt

	# macOS compatibility
	if not set -q EUID
		set EUID (id -u)
	end

	if test "$EUID" -eq 0
		set prompt "#"
	else
		set prompt "%"
	end

	if test "$exit_code" -ne 0
		set prompt (set_color -o red)"$prompt"(set_color normal)
	end

	echo "$prompt "
end

function aleksa_fish_prompt
	# Save old exit code first.
	set -l exit_code $status

	# Locals.
	set -l user_prompt
	set -l path_prompt
	set -l ret_prompt

	# macOS compatibility
	if not set -q EUID
		set EUID (id -u)
	end

	# User information
	if test "$EUID" -eq 0
		set user_prompt (set_color -o red)(hostname -f)(set_color normal)
	else
		set user_prompt (set_color -o green)"$USER"(set_color green)@(hostname -f)(set_color normal)
	end

	# Path information.
	set path_prompt (printf "%s%s%s%s%s" (set_color -o blue) (__nice_path (pwd)) (set_color normal) (__git_info) (__hg_info))

	# Return prompt based on exit code of last command.
	set ret_prompt (__ret_prompt $exit_code)

	# Actually set up prompts.
	printf "%s %s::%s %s %s\n" "$user_prompt" (set_color cyan) (set_color normal) "$path_prompt" "$ret_prompt"
end

function aleksa_fish_right_prompt
	function __loadavg
		test -f "/proc/loadavg"; and echo (cat /proc/loadavg ^/dev/null | cut -d' ' -f1); or echo ""
	end

	function __nproc
		echo (nproc ^/dev/null; or echo "?")
	end

	printf "[%s %s(%s)]" (uname -o) (__loadavg) (__nproc)
end
