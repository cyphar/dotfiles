" dotfiles: collection of my personal dotfiles
" Copyright (C) 2012-2019 Aleksa Sarai <cyphar@cyphar.com>
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

" Don't kill trailing whitespace on-save.
augroup trailing_whitespace_kill
	autocmd!
augroup END

" Make append() look like it's inserting after the current line.
function! AppendLine(text)
	let w:wv = winsaveview()
	call append('.', a:text)
	call winrestview(w:wv)
endfunction

" Some helpful macros while dealing with LKML.
map <leader>Ks :call AppendLine("Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>")<cr>
map <leader>Ka :call      AppendLine("Acked-by: Aleksa Sarai <cyphar@cyphar.com>")<cr>
map <leader>Kr :call   AppendLine("Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>")<cr>
