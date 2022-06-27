scriptencoding utf-8
set encoding=utf-8

"No compatibility mode
set nocompatible

"Fix problem where vim starts in REPLACE mode
"See https://www.reddit.com/r/bashonubuntuonwindows/comments/ijys54/has_anyone_else_started_seeing_vim_open_in/
set t_u7=

"Tell vim the escape codes it needs for italics
set t_ZH=[3m
set t_ZR=[23m

"Show command keystrokes
set showcmd

"Line display stuff
set number
"relative number
"set rnu
set cursorline
set colorcolumn=81

" Prepend ~/.backup to backupdir so that Vim will look for that directory
" before littering the current dir with backups.
" You need to do "mkdir ~/.backup" for this to work.
set backupdir^=~/.backup

" Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
" full path into swap file names.
set dir^=~/.backup//

set undodir^=~/.undo

"Buffers


" Ignore case when searching
" - override this setting by tacking on \c or \C to your search term to make
"   your search always case-insensitive or case-sensitive, respectively.
set ignorecase

"Search highlighting WHILE search but not after
set incsearch

"Search highlighting AFTER search
set hlsearch

"Allow mouse scrolling and such
set mouse=a

"If version <= 7.4, manually load plugins:
if v:version <= 7.4
    set runtimepath^=~/.vim/pack/dist/start/gruvbox
    set runtimepath^=~/.vim/pack/dist/start/vim-airline
    set runtimepath^=~/.vim/pack/dist/start/vim-airline-themes
    set runtimepath^=~/.vim/pack/dist/start/vim-closetag
    set runtimepath^=~/.vim/pack/dist/start/vim-rainbow
endif

"Tab settings
set shiftwidth=4
set softtabstop=0
set tabstop=4
set autoindent
set smartindent
set expandtab

"Turn off mode indicator (airline is better)
set noshowmode

set backspace=2

"Turn on filetype detection
filetype plugin indent on

"File-type specific
autocmd FileType make setlocal noexpandtab
autocmd FileType scheme setlocal tabstop=2 shiftwidth=2
autocmd FileType asm setlocal tabstop=8 softtabstop=8 shiftwidth=8
autocmd BufReadPost *.rkt,*.rktl set filetype=scheme
autocmd FileType text setlocal tw=79 fo=tcqln spelllang=en_us
autocmd FileType markdown setlocal tw=79 fo=tcqln spelllang=en_us
autocmd FileType tex setlocal tw=79
autocmd BufReadPost *.tex setlocal tw=79
au BufRead,BufNewFile *.lhs set filetype=lhaskell
au BufRead,BufNewFile *.tsx set filetype=javascript
autocmd BufRead,BufNewFile,BufReadPost *.scala set ft=scala

"Save view settings (e.g. cursor position, folds,...)
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

"autocmd FileType markdown inoremap <CR><CR> <Space><Space><CR>
"autocmd FileType markdown inoremap <CR> <CR><CR>
"autocmd FileType markdown inoremap <CR>- <CR>-<Space>

"Color scheme
"and termcolors hackery
set termguicolors
if !exists('g:loaded_color')
    let g:loaded_color = 1

    let iterm_profile = $ITERM_PROFILE
    if iterm_profile == "dark"
        set background=dark
    elseif iterm_profile == "light"
        set background=light
    else
        set background=dark
    endif

    colorscheme gruvbox
    let g:gruvbox_termcolors=16
    let g:gruvbox_transparent_bg=1
    let g:airline_theme='gruvbox'
endif
if !exists('g:syntax_on')
    syntax enable
endif

au vimenter * hi! EndOfBuffer ctermbg=none guibg=NONE
au BufWinEnter * hi! SpecialKey ctermfg=239 guifg=#4e4e4e
au vimenter * hi! Terminal ctermbg=none guibg=NONE
au vimenter * hi! Normal ctermbg=none guibg=NONE
highlight Comment cterm=italic

"Conceal settings
au BufWinEnter * set conceallevel=2
au BufWinEnter * set concealcursor=nc

"Custom commands
"Build a .tex file to pdf
command Pdf !clear; pdflatex.exe -quiet %

"Rainbow parentheses highlighting
"augroup rainbow_paren
"    autocmd!
"    autocmd FileType lisp,scheme RainbowToggleOff
"augroup END
"let g:rainbow_active = 0

"vim-slime settings
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_haskell_ghci_add_let = 0
let g:slime_python_ipython = 1
let g:slime_no_mappings = 1
xmap <Leader>s <Plug>SlimeRegionSend
nmap <Leader>s <Plug>SlimeParagraphSend
"No mapping for this, but can always redo config with `:SlimeConfig`!

"coc settings
if v:false
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
endif

inoremap <silent><expr> <c-@> coc#refresh()

nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

"Show buffers in airline
let g:airline#extensions#tabline#enabled = 1

"Haskell vim syntax highlighting settings
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords

let g:haskell_indent_if = 0
let g:haskell_indent_case = 4
let g:haskell_indent_let = 4
let g:haskell_indent_where = 4
let g:haskell_indent_before_where = 4
let g:haskell_indent_after_bare_where = 4
let g:haskell_indent_do = 4
let g:haskell_indent_in = 4
let g:haskell_indent_guard = 4

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

"More of the same movement by display line, but actually redefining j and k
nnoremap <C-j> j
nnoremap <C-k> k
nnoremap j gj
nnoremap k gk
"onoremap <silent> j gj
"onoremap <silent> g gk
"I would make equivalent changes for g0 and g$, but then I would have to make
"0 accessible by <C-0> and $ by <C-$>, which are very inconvenient keystrokes.
"Since these are used less frequently than j and k, I would be comfortable
"using g0 and g$ as normal, or alternatively the <Home> and <End> defined
"above.

"Tab always indents, Shift-Tab always deindents
"In insert mode, tab still tabs forward from the cursor, not the whole line.
"To tab the whole line, use <C-T>.
inoremap <S-Tab> <C-D>
"nnoremap <Tab> >>_
"nnoremap <S-Tab> <<_
"vnoremap <Tab> >
vnoremap <S-Tab> <

"Reload screen also clears previous search
nnoremap <C-l> :nohlsearch<CR><C-l>

"Insert date
inoremap <Leader>d <C-r>=strftime('%Y-%m-%d')<CR>
"Insert time
inoremap <Leader>t <C-r>=strftime('%H:%M')<CR>
"Insert datetime
inoremap <Leader>f <C-r>=strftime('%Y-%m-%d %H:%M:%S%z')<CR>

"Open ghci with \g
autocmd FileType haskell nnoremap <Leader>g :silent !clear; ghci %<CR>:redraw!<CR>

"Open netrw with \e
nnoremap <Leader>e :Vexplore<CR>

"Run Makefile with \m
"inoremap <Leader>m <C-o>:make<CR>
nnoremap <Leader>m :silent execute "make"<CR><C-l>

"The following tmux commands are extremely evil
"Send command to rightmost tmux pane with \r
"nnoremap <Leader>r :silent execute "!tmux command-prompt -p 'Command to run:' 'send-keys -t {right} C-l C-a C-k \"\\%1\" Enter'"<CR><C-l>
"Send previous command to rightmost tmux pane with \p
"nnoremap <Leader>p :silent execute "!tmux send-keys -t {right} C-l C-a C-k '\\!\\!' Enter"<CR><C-l>
"Send make command to rightmost tmux pane with \n
"nnoremap <Leader>n :silent execute "!tmux send-keys -t {right} C-l C-a C-k 'make' Enter"<CR><C-l>
"Send command to run the current file as a script with \b (requires '#!/bin/???' in header)
"nnoremap <Leader>b :silent execute "!tmux send-keys -t {right} C-l C-a C-k '%:p' Enter"<CR><C-l>
"Send command to run the current file in vim pane (requires '#!/bin/???' in
"header)
"nnoremap <Leader>v :execute "!clear && %:p"<CR>

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

"Display spaces and other whitespace characters
let is_lcs_on = 0
nnoremap <Leader>l :call LcsToggle()<cr>
function! LcsToggle()
    if g:is_lcs_on == 0
            setlocal list listchars=space:·,eol:\ ,trail:⣿,nbsp:␣,tab:➤,
        let g:is_lcs_on = 1
    else
        if &filetype ==# 'markdown'
            "␣
            "․
            "~
            setlocal list listchars=space:\ ,eol:\ ,trail:․,nbsp:\ ,tab:│·,
        else
            setlocal list listchars=space:\ ,eol:\ ,trail:\ ,nbsp:\ ,tab:│·,
        endif
        let g:is_lcs_on = 0
    endif
endfunction

autocmd FileType,BufEnter * call LcsToggle()
