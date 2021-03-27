"Only the haskell parts. This doesn't work on its own. This is really just for
"reference and for copying into the larger gruvbox.vim if you like it.
"There is probably a better way to do this.
"
"Also I added a new color GruvboxBrown but it didn't really work so I think
"you can just use GruvboxRed and it'll be fine. For this reason I preemptively
"replaced those instances here but you can try to implement the brown color in
"Gruvbox to see if it works. The color is defined as:
"let s:gb.brown = ['#c55b38', 52] " 197-91-56


" Haskell: {{{

" hi! link haskellType GruvboxYellow
" hi! link haskellOperators GruvboxOrange
" hi! link haskellConditional GruvboxAqua
" hi! link haskellLet GruvboxOrange
"
"hi! link haskellType GruvboxFg1
hi! link haskellType GruvboxYellow
"hi! link haskellIdentifier GruvboxFg1
hi! link haskellIdentifier GruvboxYellow
"hi! link haskellSeparator GruvboxFg1
hi! link haskellSeparator GruvboxBrown
hi! link haskellDelimiter GruvboxBrown
hi! link haskellOperators GruvboxBlue
""
"hi! link haskellBacktick GruvboxOrange
hi! link haskellBacktick haskellOperators
"hi! link haskellStatement GruvboxOrange
hi! link haskellConditional GruvboxGreen
"

hi! link haskellKeyword GruvboxGreen
hi! link haskellLet GruvboxGreen
hi! link haskellDefault GruvboxGreen
hi! link haskellWhere GruvboxGreen
hi! link haskellBottom GruvboxGreen
hi! link haskellBlockKeywords GruvboxGreen
hi! link haskellImportKeywords GruvboxAqua
hi! link haskellDecl GruvboxAqua
hi! link haskellDeclKeyword GruvboxGreen
hi! link haskellDeriving GruvboxGreen
hi! link haskellDerive GruvboxGreen
hi! link haskellAssocType GruvboxGreen
"
"hi! link haskellNumber GruvboxPurple
"hi! link haskellPragma GruvboxPurple
"
hi! link haskellString GruvboxOrange
hi! link haskellChar GruvboxOrange
"
" }}}
