# dotfiles #
These are my personal configuration files. Feel free to use them yourself if you
wish.

## Download ##
When cloning this repo, ensure that you clone it recursively (to ensure that
submodules are also cloned):

```
$ git clone --recursive git://github.com/cyphar/dotfiles.git
```

You could of course do something like this:

```
$ git clone git://github.com/cyphar/dotfiles.git
$ cd dotfiles
$ git submodules init
$ git submodules update
```

But who needs all that typing? `;)`

## Install ##
Run the script `install` in the root of the project to install the configs.

## Requirements ##
You NEED the following packages to ensure that the configs work properly:

- figlet
- exuberant-ctags
- keychains

## (Un)license ##
Apart from files where specifically specified (e.g vim plugins), these
configuration files have been released under the unlicense (in the hope that
they would be useful to others):

```
This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
```
