
" user filetype file
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect

au! BufNewFile,BufRead *.json         setf javascript
au! BufNewFile,BufRead *.applescript  setf applescript
au! BufNewFile,BufRead *.plt,.gnuplot setf gnuplot
au! BufNewFile,BufRead *.svg          setf xml
au! BufNewFile,BufRead *.xhtml        setf xml
au! BufNewFile,BufRead *.vm           setf html
au! BufNewFile,BufRead *.pdf          setf pdf
au! BufNewFile,BufRead *.ck           setf ck 

augroup END

