" Make external commands work through a pipe instead of a pseudo-tty
set noguipty

if has('gui_gtk2')
	set guifont=Bitstream\ Vera\ Sans\ Mono\ 8
elseif has('macunix')
	"set gfn=Monaco:h12
	set guifont=Lucida\ Sans\ Typewriter\ Regular:h12
else
	set guifont=-misc-fixed-medium-r-normal--10-130-75-75-c-70-iso8859-15
endif

" No toolbar
set guioptions-=T

" No blinking cursor (powersave)
let &guicursor = &guicursor . ",a:blinkon0"
