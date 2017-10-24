" Vim color file
" Maintainer:   Hans Fugal <hans@fugal.net>
" Last Change:  5 Oct 2001
" URL:		http://fugal.net/vim/colors/bw.vim
"
" Modified: ML

" cool help screens
" :he group-name
" :he highlight-groups
" :he gui-colors
"
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="bw"

hi SpecialKey     gui=bold			guifg=NONE
hi NonText        gui=bold	    	guifg=NONE
hi Directory      gui=bold	    	guifg=NONE
hi ErrorMsg       gui=standout    	guifg=NONE
hi IncSearch      gui=reverse	    guifg=NONE
hi Search         gui=reverse	    guifg=NONE
hi MoreMsg        gui=bold	    	guifg=NONE
hi ModeMsg        gui=bold	    	guifg=NONE
hi LineNr         gui=reverse   	guifg=NONE
hi Question       gui=standout    	guifg=NONE
hi StatusLine     gui=bold,reverse	guifg=NONE
hi StatusLineNC   gui=reverse		guifg=NONE
hi VertSplit      gui=reverse		guifg=NONE
hi Title          gui=bold			guifg=NONE
hi Visual         gui=reverse		guifg=NONE
hi VisualNOS      gui=bold,underline	guifg=NONE
hi WarningMsg     gui=standout		guifg=NONE
hi WildMenu       gui=standout		guifg=NONE
hi Folded         gui=standout		guifg=NONE
hi FoldColumn     gui=standout		guifg=NONE
hi DiffAdd        gui=bold	        guifg=NONE
hi DiffChange     gui=bold	        guifg=NONE
hi DiffDelete     gui=bold	        guifg=NONE
hi DiffText       gui=reverse	    guifg=NONE
hi Comment        gui=italic		guifg=grey70
hi Constant       gui=underline		guifg=NONE
hi Special        gui=bold,italic	guifg=NONE
hi Identifier     gui=italic		guifg=NONE
hi Statement      gui=bold			guifg=NONE
hi PreProc        gui=bold			guifg=NONE
hi Type           gui=bold,italic	guifg=NONE
hi Underlined     gui=underline		guifg=NONE
hi Ignore         gui=bold			guifg=NONE
hi Error          gui=reverse		guifg=NONE
hi Todo           gui=standout		guifg=NONE
