" Space as leader (let mapleader="<Space>")
map <Space> \

" Load pathogen
filetype off
call pathogen#infect('~/etc/vim.git/bundle/{}')
call pathogen#helptags()

" syntastic
let g:syntastic_check_on_open = 1
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options =
			\ ' -std=c++14
			\   -Werror -Weverything
			\   -Wno-c++98-compat -Wno-c++98-compat-pedantic
			\   -Wno-missing-prototypes
			\   -Wno-old-style-cast
			\   -Wno-unused-macros
			\   -Wno-weak-vtables
			\ '
if has('macunix')
	let g:syntastic_cpp_include_dirs = [
				\ '/Users/laurin/macports/include/QtGui',
				\ '/Users/laurin/macports/include/QtCore',
				\ '/Users/laurin/macports/include/QtSvg',
				\ ]
endif
let g:syntastic_rst_checkers = ['rstcheck']
let g:syntastic_python_checkers = ['python', 'pylint']

" Set highlight on search
set hlsearch
hi search guibg=LightBlue

" Colorscheme
set t_Co=256
let g:solarized_termcolors=256
syntax enable
if has('macunix')
	" Terminal with the "Pro" theme has a black background
	set background=dark
else
	colorscheme solarized
endif

if has("autocmd")
	" Uncomment the following to have Vim jump to the last position when
	" reopening a file
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules according to
" the detected filetype. Per default Debian Vim only load filetype
" specific plugins.
filetype indent on
filetype plugin on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set autowrite		" Automatically save before commands like :next and :make
"set hidden			" Hide buffers when they are abandoned
set mouse=a			" Enable mouse usage (all modes) in terminals


" Do not keep backups (filename~)
set nobackup
set nowritebackup
" Groups swap files (.filename.swp)
set directory=~/.vimswaps,/tmp,.

" Sh-style tab completion
set wildmode=longest,list

" Explicitely enable modeline
set nocompatible
if $USER != 'root'
	set modeline
	set modelines=2
else
	set nomodeline
	set modelines=0
endif

" Number lines
set number
if version >= 703
	" relative number in normal mode
	autocmd InsertEnter * :set number
	autocmd InsertLeave * :set relativenumber
	" relative number is window has focus
	autocmd FocusLost * :set number
	autocmd FocusGained * :set relativenumber
endif


" Clever grep
set grepprg=grep\ -nH\ $*

" Tab behavior
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround

" Split creation
nmap <leader>H :topleft vnew<cr>
nmap <leader>J :botright new<cr>
nmap <leader>K :topleft new<cr>
nmap <leader>L :botright vnew<cr>

nmap <leader>h :leftabove vnew<cr>
nmap <leader>j :rightbelow new<cr>
nmap <leader>k :leftabove new<cr>
nmap <leader>l :rightbelow vnew<cr>

" Split navigation (normal mode)
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
" Split navigation (terminal)
if has('nvim')
	tnoremap <C-\><C-\> <C-\><C-N>
	tnoremap <C-H> <C-\><C-N><C-W><C-H>
	tnoremap <C-J> <C-\><C-N><C-W><C-J>
	tnoremap <C-K> <C-\><C-N><C-W><C-K>
	tnoremap <C-L> <C-\><C-N><C-W><C-L>
endif
" Delete buffer with bbye
nnoremap <leader>bd :Bdelete<CR>

" setlocal spell spelllang=en,fr
" runtime ftplugin/man.vim

" Case insensitive but if uppercase used in search
set incsearch		" Incremental search
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
" Assume /g flag on :s substitutions to replace all matches in a file
set gdefault
" Redefine keys for searches so that the search result is always in the middle
" of the screen.
" From Andrew W. Freeman [andrewf@voicenet.com] Thu 1999-05-13 11:36
nmap n nmzz.`z
nmap N Nmzz.`z
nmap * *mzz.`z
nmap # #mzz.`z
nmap g* g*mzz.`z
nmap g# g#mzz.`z

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" Force hjkl
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" Force normal mode to move in file
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Use the visual bell instead of the audible one
set vb

" Mappings
" Insert a blank line after the current line
" but stay in normal mode
nmap <cr> o<esc>

" setlocal spell spelllang=en,fr
" runtime ftplugin/man.vim

if has('macunix')
	" get rid of the highlighted text
	map <silent> <D-/> :let @/=""<CR>  :echo "Highlights Cleared"<CR>
endif

" try to avoid misspelling words in the first place -- have the insert mode
" <Ctrl>+N/<Ctrl>+P keys perform completion on partially-typed words by
" checking the Linux word list and the personal `Ispell' dictionary; sort out
" case sensibly (so that words at starts of sentences can still be completed
" with words that are in the dictionary all in lower case):
"execute 'set dictionary+=' . PersonalDict
"set dictionary+=/usr/dict/words
"set complete=.,w,k
"set infercase

" do not expandtab in makefile
autocmd FileType make set noexpandtab


if exists('+colorcolumn')
	set colorcolumn=+1
else
	autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Date in printheader
set printheader=%<%f%h%m\ \ %{strftime('%m/%d/%y\ %X')}%=Page\ %N

" Fix common typo
cnoreabbrev Set set

" ReST structure
nnoremap <leader>0 yypv$r=yykP
nnoremap <leader>1 yypv$r=
nnoremap <leader>2 yypv$r-
nnoremap <leader>3 yypv$r~
nnoremap <leader>4 yypv$r^

" reformat paragraph
nnoremap <leader>q gq)
nnoremap <leader>Q {gq}

" insert newline from normal mode
nnoremap <leader>o mzo<esc>`z
nnoremap <leader>O mzO<esc>`z

" change colorscheme for printing
command! -nargs=* Hardcopy call DoMyPrint('<args>')
function DoMyPrint(args)
	let colorsave=g:colors_name
	color bw
	exec 'hardcopy '.a:args
	exec 'color '.colorsave
endfunction
nnoremap <leader>p <esc>:Hardcopy<cr>
