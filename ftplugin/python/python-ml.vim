" Sane spacing for Python
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
"setlocal textwidth=80
setlocal smarttab
setlocal expandtab

" Make folding to my likings,
" to use with python_fold.vim
" http://www.vim.org/scripts/script.php?script_id=515
setlocal foldnestmax=1
setlocal foldlevel=3

" pyflakes let quickfix window to PEP8
let g:pyflakes_use_quickfix = 0

" shortcut for PEP8 plugin
"let g:pep8_map='<F8>'

" fix syntax highlight of long docstrings
let python_slow_sync=1

" highlight all occurences of variable under the cursor
"function! HighlightVariableUnderCursos()
"	if synIDattr(synIDtrans(synID(line("."), col("."), 0)), "name") == ""
"		autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
"	endif
"endfunction

"autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
" alternative
" :set hlsearch, then * or #
