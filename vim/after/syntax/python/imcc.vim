" Ideas and code from I. McCracken
" http://concisionandconcinnity.blogspot.de/2009/07/vim-part-i-improved-python-syntax.html

" syntax highlight self
syn match pythonSelf "self*" display
hi link pythonSelf Special

" separate doctring/other strings and comments, after I. McCracken
syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError

hi link pythonDocstring Comment

" color code assignment, after I. McCracken
syn match pythonAssignment "+=\|-=\|\*=\|/=\|//=\|%=\|&=\||=\|\^=\|>>=\|<<=\|\*\*="
syn match pythonAssignment "="
syn match pythonArithmetic "+\|-\|\*\|\*\*\|/\|//\|%\|<<\|>>\|&\||\|\^\|\~"
syn match pythonComparison "<\|>\|<=\|>=\|==\|!=\|<>"

hi link pythonAssignment Operator
hi link pythonArithmetic Operator
hi link pythonComparison Operator


