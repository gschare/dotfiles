"No compatibility mode
set nocompatible

"Fix problem where vim starts in REPLACE mode
"See https://www.reddit.com/r/bashonubuntuonwindows/comments/ijys54/has_anyone_else_started_seeing_vim_open_in/
set t_u7=

"Show command keystrokes
set showcmd

"Line display stuff
set number
"set relativenumber
"set cursorline

" Prepend ~/.backup to backupdir so that Vim will look for that directory
" before littering the current dir with backups.
" You need to do "mkdir ~/.backup" for this to work.
set backupdir^=~/.backup

" Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
" full path into swap file names.
set dir^=~/.backup//

" Ignore case when searching
" - override this setting by tacking on \c or \C to your search term to make
"   your search always case-insensitive or case-sensitive, respectively.
set ignorecase

"Turn on syntax highlighting
filetype plugin indent on
syntax on

"Search highlighting WHILE search but not after
set incsearch

"Search highlighting AFTER search
set hlsearch

"Allow mouse scrolling and such
set mouse=a

"Tab settings
set shiftwidth=4
set softtabstop=0
set tabstop=4
set autoindent
set smartindent
set expandtab

"File-type specific
autocmd FileType make setlocal noexpandtab
autocmd FileType scheme setlocal tabstop=2 shiftwidth=2
autocmd BufReadPost *.rkt,*.rktl set filetype=scheme
autocmd FileType text setlocal textwidth=80 nospell "spelllang=en_us
au BufRead,BufNewFile *.lhs set filetype=lhaskell
au BufRead,BufNewFile *.tsx set filetype=javascript

"Save view settings (e.g. cursor position, folds,...)
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

"Custom commands
"Build a .tex file to pdf
command Pdf !clear; pdflatex.exe -quiet %

"Rainbow parentheses highlighting
augroup rainbow_paren
    autocmd!
    autocmd FileType lisp,scheme RainbowToggleOff
augroup END
let g:rainbow_active = 0

"Haskell vim syntax highlighting settings
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_indent_if = 3
let g:haskell_indent_case = 2
let g:haskell_indent_let = 4
let g:haskell_indent_where = 6
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2
let g:haskell_indent_do = 3
let g:haskell_indent_in = 1
let g:haskell_indent_guard = 2

"HTML closetag settings

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

"Color scheme
"and termcolors hackery
autocmd vimenter * colorscheme gruvbox
set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set term=screen-256color
autocmd vimenter * let g:airline_theme='gruvbox'
autocmd vimenter * let g:gruvbox_termcolors=16
autocmd vimenter * set bg=dark
autocmd vimenter * hi! Normal ctermbg=NONE guibg=NONE
autocmd vimenter * hi! NonText ctermbg=NONE guibg=NONE
autocmd vimenter * hi! Terminal ctermbg=NONE guibg=NONE

"Turn off mode indicator (airline is better)
set noshowmode

"Conceal settings
setlocal conceallevel=0
set concealcursor=nciv

"Custom keybindings

"Escape with double jj
inoremap jj <ESC>
noremap <C-Up> 5k
noremap <C-Down> 5j

"Arrow & special movements go by display line, not actual line
noremap  <Up>   gk
noremap  <Down> gj
noremap  <Home> g<Home>
noremap  <End>  g<End>
inoremap <Up>   <C-o>gk
inoremap <Down> <C-o>gj
inoremap <Home> <C-o>g<Home>
inoremap <End>  <C-o>g<End>

"Tab always indents, Shift-Tab always deindents
"In insert mode, tab still tabs forward from the cursor, not the whole line.
"To tab the whole line, use <C-T>.
inoremap <S-Tab> <C-D>
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >
vnoremap <S-Tab> <

"Reload screen also clears previous search
nnoremap <C-l> :nohlsearch<CR><C-l>

"Open ghci with \g
nnoremap <Leader>g :silent !clear; ghci %<CR>:redraw!<CR>

"Insert lambda with \l
inoremap <Leader>l <C-v>u03bb

"Run Makefile with \m
"inoremap <Leader>m <C-o>:make<CR>
nnoremap <Leader>m :silent execute "make"<CR><C-l>

"The following tmux commands are extremely evil
"Send command to rightmost tmux pane with \r
nnoremap <Leader>r :silent execute "!tmux command-prompt -p 'Command to run:' 'send-keys -t {right} C-l C-a C-k \"\\%1\" Enter'"<CR><C-l>
"Send previous command to rightmost tmux pane with \p
nnoremap <Leader>p :silent execute "!tmux send-keys -t {right} C-l C-a C-k '\\!\\!' Enter"<CR><C-l>
"Send make command to rightmost tmux pane with \m
nnoremap <Leader>n :silent execute "!tmux send-keys -t {right} C-l C-a C-k 'make' Enter"<CR><C-l>
"Send command to run the current file as a script with \b (requires '#!/bin/???' in header)
nnoremap <Leader>b :silent execute "!tmux send-keys -t {right} C-l C-a C-k '%:p' Enter"<CR><C-l>
"Send command to run the current file in vim pane (requires '#!/bin/???' in
"header)
nnoremap <Leader>v :execute "!clear && %:p"<CR>

"Shift-Space in insert mode enters normal mode
"inoremap <S-Space> <Esc>
"Shift-Space in normal mode enters insert mode
"nnoremap <S-Space> i

"Automatic closings
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
set pastetoggle=<F3>

"Open split panes to right and bottom
set splitright
"set splitbelow
