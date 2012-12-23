"Ensure that this config is only used with Vim and not with Vi
set nocompatible

" Activate pathogen and include all bundles in the .vim/bundle directory
call pathogen#infect()

if has("autocmd")
	" Do correct indenting based on file 
	filetype plugin indent on
else
	" Else use the standard smart indent
	set smartindent
endif

" Enable syntax
if &t_Co > 2 || has("gui_running")
	syntax enable
endif

if &t_Co >= 256 || has("gui_running")
	set background=dark
	colorscheme ir_black
else
	colorscheme ir_black
endif

" Rebind the mapleader
let mapleader = ","

set hidden
set autoread		" Reload the file
set number			" Line numbers
set noerrorbells	" No error beep
set tabstop=8		" Size of hard tabs
set shiftwidth=8	" Number of spaces for autoindent
set ignorecase		" Ignore the case of a search
set smartcase		" ... as long as it doesn't contain a capital

set nobackup		" I can track my own changes,
set noswapfile		" ... thanks.

" Quick-save and close
nmap <leader>w :w!<cr>
nmap <leader>q :wq!<cr>
nmap <leader>x :q!<cr>

" Reselect the deselected blocks in visual mode
vnoremap < <gv
vnoremap > >gv

" Stop your shift-finger from falling off
nore ; :
nore , ;
