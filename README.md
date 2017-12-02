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
Apart from files where specifically specified (e.g vim plugins), any scripts
associated with this dotfiles repo have been released under the GNU GPLv3 or
later. Any non-functional works (purely configuration data) is released under
the MIT/X11 license. Each file is marked conspicuously to make the license used
clear.

GNU GPLv3 or later:

```
dotfiles: collection of my personal dotfiles [code]
Copyright (C) 2012-2017 Aleksa Sarai <cyphar@cyphar.com>

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

MIT/X11 License:

```
dotfiles: collection of my dotfiles [configuration]
Copyright (C) 2012-2017 Aleksa Sarai <cyphar@cyphar.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
