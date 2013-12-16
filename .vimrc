" cyphar's .vimrc
"
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
au InsertCharPre,InsertEnter,InsertLeave * match ExtraWhitespace /\s\+$/
" Crush that whitespace.
au FileWritePre,FileAppendPre,FilterWritePre,BufWritePre * :%s/\s\+$//ge

" Can slow things down.
au InsertCharPre * match ExtraWhitespace /\s\+$/

" Enable block indentation and filetype-stuff.
if has('autocmd')
	filetype indent on
endif

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

" We are using hard tabs, like Cthulu intended.
set tabstop=4
set shiftwidth=4
set noexpandtab

" Did someone say glyphs?
set encoding=utf-8

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
let delimitMate_matchpairs = "(:),[:],{:},<:>"

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
