" dotfiles: collection of my personal dotfiles [code]
" Copyright (C) 2012-2018 Aleksa Sarai <cyphar@cyphar.com>
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

" The reason this file is released under the GPLv3 is because vim
" configuration files are technically source code, and I will probably
" end up adding more complicated configurations as NeoVim gets Lua
" support into the configuration file handling.

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

" Dark-As-My-Soul colourscheme.
set background=dark
colorscheme solarizeddark

" Rebind the mapleader.
let mapleader = "?"

" Basic stuff.
set hidden
set autoread
set noerrorbells
set nowrap

" SENTENCE DOUBLE-SPACING SHOULDN'T BE THE DEFAULT.
set nojoinspaces

" Put swap files inside the same directory as the file.
set directory=.

" Line numbering.
set number relativenumber
augroup NumberToggle
	au!
	au BufEnter,FocusGained,InsertLeave * set   relativenumber
	au BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" I don't use arrow keys.
map  <up>    <nop>
imap <up>    <nop>
map  <down>  <nop>
imap <down>  <nop>
map  <left>  <nop>
map  <right> <nop>
imap <left>  <nop>
imap <right> <nop>

" No mouse control.
set mouse=

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
set clipboard+=unnamedplus
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

" Set up delimit-mate.
" XXX: These are objectively horrible, I need to fix this.
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
