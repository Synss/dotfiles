set makeprg=pdflatex\ \-file\-line\-error\ \-interaction=nonstopmode\ $*\\\|\ grep\ \-E\ '\\w+:[0-9]{1,4}:\\\ ' 
set errorformat=%f:%l:\ %m 

map <buffer> ,p :w<CR>:make %<<CR>
map <buffer> ,b :!bibtex % &
map <buffer> ,v :!open %<.pdf &
map <buffer> ,t :w !pdflatex % &

" Word wrapping
" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
setlocal wrap
setlocal linebreak
setlocal formatoptions+=1

" Spell check
set spell
set spelllang=en_us
"set spelllang=fr

"let b:tex_flavor='pdflatex'
"compiler tex

" Enable Conceal
set cole=2
hi Conceal guibg=White guifg=Brown

