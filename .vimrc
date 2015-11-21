" dotfiles: a collection of configuration files
" This is free and unencumbered software released into the public domain.

" Anyone is free to copy, modify, publish, use, compile, sell, or
" distribute this software, either in source code form or as a compiled
" binary, for any purpose, commercial or non-commercial, and by any
" means.

" In jurisdictions that recognize copyright laws, the author or authors
" of this software dedicate any and all copyright interest in the
" software to the public domain. We make this dedication for the benefit
" of the public at large and to the detriment of our heirs and
" successors. We intend this dedication to be an overt act of
" relinquishment in perpetuity of all present and future rights to this
" software under copyright law.

" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
" IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
" OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
" ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
" OTHER DEALINGS IN THE SOFTWARE.

" N.B. Opening vim < 7.3 with this config will cause it to print errors
" You need to have a version of vim installed WITH gui support (+gui when
" compiled). Also note that, even if you have vim +gui, it still will not
" work if you use the "linux" terminal (without Xorg).

" Activate pathogen and include all bundles in the .vim/bundle directory.
call pathogen#infect()

" Ensure that this config is only used with Vim and not with Vi.
set nocompatible

" Make backspace work.
set backspace=indent,eol,start

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Now we set some defaults for the editor
set history=50
set ruler

" Nothing good ever came out of modeline.
" Seriously. Talk about a security hole.
set nomodeline

" Make the whitespace RED
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
au BufWinEnter,InsertEnter,InsertLeave * match ExtraWhitespace /\s\+$/
" Can slow things down, but show whitespace as red while typing.
au InsertCharPre * match ExtraWhitespace /\s\+$/

" Crush that whitespace.
" This can be a problem for formats that depend on trailing whitespace (see:
" git format-patch). In such cases, just use `noa w` when saving.
au FileWritePre,FileAppendPre,FilterWritePre,BufWritePre * :%s/\s\+$//ge

" Hopefully I can remove this some day when 80 characters is no longer the
" standard.
set colorcolumn=80

" Enable block indentation and filetype-stuff.
if has('autocmd')
	filetype indent plugin on
endif

" Omnicompletion
set omnifunc=syntaxcomplete#Complete

" Enable syntax highlighting.
if &t_Co > 2 || has('gui_running')
	syntax enable
endif

" Remove gvim's redundant toolbars.
" Not that I use gvim ... much.
set go=

" Dark-As-My-Soul colourscheme.
set background=dark
colorscheme solarizeddark

" Rebind the mapleader.
let mapleader = "?"

" Automatically reload vimrc when it's saved.
au BufWritePost .vimrc so ~/.vimrc

" Basic stuff.
set hidden
set autoread
set number
set noerrorbells
set nowrap

" I *need* to stop using the arrow keys.
map  <up>    <nop>
imap <up>    <nop>
map  <down>  <nop>
imap <down>  <nop>
map  <left>  <nop>
map  <right> <nop>
imap <left>  <nop>
imap <right> <nop>

" We are using hard tabs, like Cthulu intended.
set tabstop=4
set shiftwidth=4
set noexpandtab

" Did someone say glyphs?
set encoding=utf-8

" Set up airline
set laststatus=2
set noshowmode
let g:airline_powerline_fonts=1
let g:airline_theme='wombat'
let g:airline#extensions#syntastic#enabled=1

" Exit every mode quickly
if !has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif

" Paste-related stuff.
set pastetoggle=<F10>
set clipboard=unnamed
au InsertLeave * set nopaste

" Scrolling is crucial.
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Syntastic stuff.
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_loc_list_height=3

" Syntastic errors.
map <F3> :Errors<cr>
map <leader>. :lprev<cr>
map <leader>/ :lnext<cr>

" Set up ctags.
let Tlist_Ctags_Cmd = "/usr/bin/env ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
map <F5> :!/usr/bin/env ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>

" Set up delimit-mate.
let delimitMate_matchpairs = "(:),[:],{:}"
let delimitMate_quotes = "\" ' `"
let delimitMate_nesting_quotes = ['"', "'", "`"]

" Enable all the things.
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1
let delimitMate_smart_quotes = 1
let delimitMate_balance_matchpairs = 1

" Easier tab management.
map <leader>n :tabprev<cr>
map <leader>m :tabnext<cr>
map <leader>tn :tabnew<cr>
map <leader>td :tabclose<cr>

" Easier split management.
map <leader>sh :vsp .<cr>
map <leader>sv :sp .<cr>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
noremap <c-m> <c-w><c-m>

" Shortcuts for end and home.
map <s-right> <end>
map <s-left> <home>

" Inserting the date is important for certain cases (see: GPG messages).
" XXX: It'd be nice if we could do this with Vim's functions.
noremap <leader>d :read !date<cr>
inoremap <leader>d <c-\><c-o>:read !date<cr>

" Speling iz gode.
noremap <leader>sc :setlocal spell! spelllang=en_au<cr>
inoremap <leader>sc <c-\><c-o>:setlocal spell! spelllang=en_au<cr>

" Reselect the deselected blocks in visual mode.
vnoremap < <gv
vnoremap > >gv

" Stop your shift-finger from falling off.
" Trust me, this *really* helps.
nore ; :
nore , ;
