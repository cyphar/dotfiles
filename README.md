# dotfiles #
These are my personal configuration files. Feel free to use them yourself if you
wish.

## Download ##
When cloning this repo, ensure that you clone it recursively (to ensure that
submodules are also cloned):

```
$ git clone --recursive https://github.com/cyphar/dotfiles.git
```

## Install ##
Run the `install.py` script in the root of this project to install the
configurations. It interactively asks you whether you'd like to install each
configuration "set" (enter no input to use the default).

`install.py` also has OS-specific hooks to preconfigure supported GNU/Linux
distributions (by installing necessary packages, and other system
configuration). At the moment, this is only supported on openSUSE Tumbleweed.
If you'd like to figure out what packages are required please take a look at
`dist/opensuse/50-packages.sh`.

## License ##

Apart from files where specifically specified (e.g vim plugins), all files are
licensed under the GNU GPLv3 or later.

```
dotfiles: collection of my personal dotfiles
Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
