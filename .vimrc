" cyphar's .vimrc
"
" N.B. Opening vim < 7.3 with this config will cause it to print errors
" You need to have a version of vim installed WITH gui support (+gui when
" compiled). Also note that, even if you have vim +gui, it still will not
" work if you use the "linux" terminal (without Xorg).

" Activate pathogen and include all bundles in the .vim/bundle directory
call pathogen#infect()

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

autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au InsertLeave * match ExtraWhitespace /\s\+$/

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
let mapleader = "?"

" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

set hidden
set autoread		" Reload the file
set number			" Line numbers
set noerrorbells	" No error beep

set tabstop=4		" Size of hard tabs
set ts=4			" Size of hard tabs
set shiftwidth=4	" Number of spaces for autoindent

set ignorecase		" Ignore the case of a search
set smartcase		" ... as long as it doesn't contain a capital

set nobackup		" I can track my own changes,
set noswapfile		" ... thanks.

set encoding=utf-8	" Enable UTF-8

"set colorcolumn=80
"highlight ColorColumn ctermbg=233

set pastetoggle=<F10>	" Toggle sane paste indentation mode
set clipboard=unnamed	" Actual copy-paste
au InsertLeave * set nopaste " Exit paste mode when leaving ins-mode

set scrolloff=8			" Number of lines from vertical edge to start scrolling
set sidescrolloff=15	" Number of cols from horizontal edge to start scrolling
set sidescroll=1		" Number of cols to scroll at a time

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
"nmap <leader>m <esc>:set cuc!<cr>

" Tab management
nnoremap <leader>n <esc>:tabprev<cr>
nnoremap <leader>m <esc>:tabnext<cr>
nnoremap <leader>tn <esc>:tabnew<cr>
nnoremap <leader>td <esc>:tabclose<cr>

" Split management
nnoremap <leader>sh <esc>:vsp .<cr>
nnoremap <leader>sv <esc>:sp .<cr>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-m> <c-w><c-m>

" Shortcuts for end and home
nnoremap <s-right> <end>
nnoremap <s-left> <home>

" Clear whitespace
map <c-w> <esc>:%s/\s\+$//g<cr>
imap <c-w> <esc>:%s/\s\+$//g<cr>i

map <leader>sc <esc>:setlocal spell! spelllang=en_au<cr>
imap <leader>sc <esc>:setlocal spell! spelllang=en_au<cr>i

" Reselect the deselected blocks in visual mode
vnoremap < <gv
vnoremap > >gv

" Stop your shift-finger from falling off
nore ; :
nore , ;
