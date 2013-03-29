" cyphar's .vimrc
"
" N.B. Opening vim < 7.3 with this config will cause it to print errors
" You need to have a version of vim installed WITH gui support (+gui when
" compiled). Also note that, even if you have vim +gui, it still will not
" work if you use the "linux" terminal (without Xorg).

" Ensure that this config is only used with Vim and not with Vi
set nocompatible

" Make backspace work.
set backspace=indent,eol,start

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Middle click usually pastes selected text inside a terminal.
" Make it accessible from the keyboard
if has('gui_running')
	" Make shift-insert work like in Xterm
	map <S-Insert> <MiddleMouse>
	map! <S-Insert> <MiddleMouse>
endif

" Now we set some defaults for the editor
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time

" Remove the low-hanging fruit, security wise
set nomodeline

" Activate pathogen and include all bundles in the .vim/bundle directory
call pathogen#infect()

if has('autocmd')
	" Do correct indenting based on file 
	filetype plugin indent on
else
	" Else use the standard smart indent
	set smartindent
endif

if &term =~ '^\(xterm\|screen\)$' && $COLORTERM == 'gnome-terminal'
	set t_Co=256
endif

" Enable syntax
if &t_Co > 2 || has('gui_running')
	syntax enable
endif

if &t_Co >= 256 || has('gui_running')
	set background=dark
	colorscheme solarizeddark
elseif $TERM != 'linux'
	set background=dark	
	colorscheme solarizeddark
else
	set background=dark
	colorscheme Tommorow-Night-Eighties
endif

" Rebind the mapleader
let mapleader = "\\"

set hidden
set autoread		" Reload the file
set number		" Line numbers
set noerrorbells	" No error beep
set tabstop=8		" Size of hard tabs
set shiftwidth=8	" Number of spaces for autoindent
set ignorecase		" Ignore the case of a search
set smartcase		" ... as long as it doesn't contain a capital

set nobackup		" I can track my own changes,
set noswapfile		" ... thanks.

" Syntastic setup
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_loc_list_height=3

map <F3> :Errors<cr>
map <leader>. <esc>:lprev<cr>
map <leader>/ <esc>:lnext<cr>

" ctags epicness
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
map <F5> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>

" Completion
set complete+=i		" Scan included files

" Ctrl-mappings
nnoremap <c-c> yy
nnoremap <c-x> dd
nnoremap <c-v> p
nnoremap <c-u> lbveU<esc>
nnoremap <c-l> lbveu<esc>

vmap <c-c> y
vmap <c-x> dd
vmap <c-v> p

imap <c-d> <esc>ddi
imap <c-z> <esc>ui
imap <c-u> <esc>llbveU<esc>i
imap <c-l> <esc>llbveu<esc>i

" Quick-save and close
nmap <leader>w :w!<cr>
nmap <leader>q :wq!<cr>
nmap <leader>x :q!<cr>

" Toggle Column Marking
nmap <leader>m <esc>:set cuc!<cr>

" Tab management
map <leader><left> <esc>:tabprev<cr>
map <leader><right> <esc>:tabnext<cr>
map <leader><up> <esc>:tabfirst<cr>
map <leader><down> <esc>:tablast<cr>
map <leader>tn <esc>:tabnew<cr>
map <leader>td <esc>:tabclose<cr>

imap <leader><left> <esc>:tabprev<cr>
imap <leader><right> <esc>:tabnext<cr>
imap <leader><up> <esc>:tabfirst<cr>
imap <leader><down> <esc>:tablast<cr>
imap <leader>tn <esc>:tabnew<cr>
imap <leader>td <esc>:tabclose<cr>

" Shortcuts for end and home
map <s-right> <end>
imap <s-right> <end>

map <s-left> <home>
imap <s-left> <home>

" Reselect the deselected blocks in visual mode
vnoremap < <gv
vnoremap > >gv

" Stop your shift-finger from falling off
nore ; :
nore , ;	
