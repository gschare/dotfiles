scriptencoding utf-8
set encoding=utf-8

"No compatibility mode
set nocompatible

"Show command keystrokes
set showcmd

"Line display stuff
set number
"relative number
"set rnu
"set cursorline
"set colorcolumn=81
set nocursorline
set colorcolumn=0
set ruler

"My favs: peachpuff, wildcharm, retrobox, habamax, lunaperche.
set background=dark
colorscheme retrobox

" Prepend ~/.backup to backupdir so that Vim will look for that directory
" before littering the current dir with backups.
" You need to do "mkdir ~/.backup" for this to work.
set backupdir^=~/.backup

" Also use ~/.backup for swap files. The trailing // tells Vim to incorporate
" full path into swap file names.
set dir^=~/.backup//

set undodir^=~/.undo

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

"Tab settings
set shiftwidth=4
set softtabstop=0
set tabstop=4
set autoindent
set smartindent
set expandtab

set backspace=2

let mapleader = " "

"Turn on filetype detection + syntax
filetype plugin indent on
syntax on

"Display spaces and other whitespace characters
let g:is_lcs_on = 0
nnoremap <leader>l :call LcsToggle()<cr>
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

function! LcsOff()
    if &filetype ==# 'markdown'
        "␣
        "․
        "~
        setlocal list listchars=space:\ ,eol:\ ,trail:․,nbsp:\ ,tab:│·,
    else
        setlocal list listchars=space:\ ,eol:\ ,trail:\ ,nbsp:\ ,tab:│·,
    endif
    let g:is_lcs_on = 0
endfunction

autocmd BufReadPost,FileType * call LcsOff()

"File-type specific
autocmd FileType make setlocal noexpandtab
autocmd FileType scheme setlocal tabstop=2 shiftwidth=2
autocmd FileType asm setlocal tabstop=8 softtabstop=8 shiftwidth=8
autocmd BufReadPost *.scm set filetype=scheme
autocmd FileType text setlocal tw=79 fo=tcqln spelllang=en_us
autocmd FileType markdown setlocal tw=79 fo=tcqln spelllang=en_us shiftwidth=2 tabstop=2
autocmd FileType tex setlocal tw=79
autocmd FileType tex setlocal noautoindent nosmartindent nocindent indentexpr=
autocmd BufReadPost *.tex setlocal tw=79
au BufRead,BufNewFile *.lhs set filetype=lhaskell
au BufRead,BufNewFile *.tsx set filetype=javascript
autocmd BufRead,BufNewFile,BufReadPost *.scala set ft=scala

"Save view settings (e.g. cursor position, folds,...)
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview

"Conceal settings
au BufWinEnter * set conceallevel=2
au BufWinEnter * set concealcursor=
au FileType markdown set foldmethod=marker

highlight Comment cterm=italic
hi Normal ctermbg=none

"Custom keybindings

"Arrow & special movements go by display line, not actual line
nnoremap <C-j> j
nnoremap <C-k> k
nnoremap j gj
nnoremap k gk

"Reload screen also clears previous search
nnoremap <C-l> :nohlsearch<CR><C-l>

"Insert date
"TODO: add more options
nnoremap <leader>d a<C-r>=strftime('%Y-%m-%d')<CR><Esc>
"Insert time
nnoremap <leader>t a<C-r>=strftime('%H:%M %Z')<CR><Esc>
"Insert datetime
nnoremap <leader>f a<C-r>=strftime('%Y-%m-%d %H:%M:%S%z')<CR><Esc>

"Open netrw with \e
nnoremap <leader>e :Lexplore<CR>

let g:netrw_banner = 0
let g:netrw_preview = 1  "Use vertical split
let g:netrw_alto = 0
let g:netrw_altv = 0
"let g:netrw_liststyle = 3 "Tree style
let g:netrw_winsize = 30 "Only take 30% of window
let g:netrw_browse_split = 0 "Open in current window (default)
let g:netrw_browser_viewer='open'
augroup AutoDeleteNetrwHiddenBuffers
  au!
  "au FileType netrw setlocal bufhidden=wipe
augroup end

"function! NetrwMapping()
"    "nmap <buffer> p P<C-w>p
"    nmap <buffer> p <CR><C-w><C-w>
"    nmap <buffer> <TAB> mf
"endfunction

"augroup netrw_mapping
"  autocmd!
"  autocmd filetype netrw call NetrwMapping()
"augroup END

"Quickfix/location keybinds
nnoremap [c :cnext<CR>
nnoremap ]c :cprevious<CR>
nnoremap [c :cfirst<CR>
nnoremap ]c :clast<CR>
nnoremap [l :lnext<CR>
nnoremap ]l :lprevious<CR>
nnoremap [l :lfirst<CR>
nnoremap ]l :llast<CR>
"Buffer keybinds
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprevious<CR>

"Davis config
"Command to save with timestamp in notes dir
function! NewNote(...)
    e `=system('bash ~/bin/new_note_name')`
    if a:0 == 0
        execute "normal i <meta tag=\"note\">"
    else
        execute "normal i <meta tag=\"" . join(a:000) . "\">"
    endif
endfunction

command! -nargs=* Note call NewNote(<f-args>)

function! NewNoteAndInsertLink(...)
    r !bash ~/bin/new_note_name
    if a:0 == 0
        call NewNote()
    else
        call NewNote(join(a:000))
    endif
endfunction

command! -nargs=* NoteAndLink call NewNoteAndInsertLink(<f-args>)

"Command to search for files with a certain tag
"Currently only allows one argument
function! FTagSearch(t)
    call s:Rg("<meta tag=\".*" . a:t . ".*\">", "~/notes/")
endfunction

command! -nargs=1 Tag call FTagSearch(<f-args>)

"Run Makefile with \m
"inoremap <Leader>m <C-o>:make<CR>
nnoremap <leader>m :silent execute "make"<CR><C-l>

"Copy current line with \c
nnoremap <leader>c "+yy

au FileType markdown nnoremap <leader>- a* [ ] <Esc>
au FileType markdown nnoremap <leader>m a<meta tag=""><C-o>h<C-x><C-k><C-p><Esc>

function! MdNextHeading(dir)
    "Want to jump to next heading at same depth (can go backwards by passing
    "argument 'b'; I will refer to the next heading from here on).
    "Jump to most recent heading and find next one with the same depth and
    "jump to it.
    "If there is a higher heading before another heading of the same depth, go
    "to that instead.
    "So essentially: if next heading is small, skip it. If it's big or the
    "same, go to it.
    "If there is not another heading at the same depth, go to the next
    "heading.
    let l:allowhigher = 0
    let l:savelinenum = line('.')
    if match(getline('.'), '^#') != -1
        let l:prevheading = line('.')
        let l:desireddepth = len(split(getline(l:prevheading))[0])
    else
        let l:prevheading = search('^#', 'bnW')
        if l:prevheading == 0
            let l:desireddepth = 1
        else
            let l:desireddepth = len(split(getline(l:prevheading))[0])
        endif
    endif
    let l:nextheading = search('^#' . '\{1,' . l:desireddepth . '\}[^#]', 'nW' . a:dir)
    let l:nextequaldepthheading = search('^#' . '\{' . l:desireddepth . '\}[^#]', 'nW' . a:dir)
    "echom 'd:' . l:desireddepth . ' next:' . l:nextheading . ' eq:' . l:nextequaldepthheading . ' line:' . l:savelinenum
    if (a:dir == '' && l:nextheading < l:nextequaldepthheading) || (a:dir == 'b' && l:nextheading > l:nextequaldepthheading)
        if l:allowhigher == 1
            exe l:nextheading
            return
        else
            echom "No more siblings at this depth"
            exe l:savelinenum
            return
        endif
    endif
    if l:nextequaldepthheading == 0
        echom "No more siblings"
        exe l:savelinenum
        return
    else
        exe l:nextequaldepthheading
        return
    endif
endfunction

au FileType markdown nnoremap gj :call MdNextHeading('')<CR>
au FileType markdown nnoremap gk :call MdNextHeading('b')<CR>

function! MdGoToDeeperHeading(dir)
    "Jump to higher or lower heading level (less or more deep). If there is no such heading, do
    "nothing.
    "Jump to most recent heading, then compute heading of depth one less or
    "one more than that, and jump to the previous or next one of those.
    let l:allowhigher = 0
    let l:savelinenum = line('.')
    if match(getline('.'), '^#') != -1
        "Case of current line is a heading
        let l:prevheading = line('.')
        let l:currentdepth = len(split(getline(l:prevheading))[0])
        if a:dir == 'b' && l:currentdepth == 1
            echom "At root"
            return
        endif
        if a:dir == 'b'
            let l:desireddepth = max([l:currentdepth - 1, 1])
        else
            let l:desireddepth = l:currentdepth + 1
        endif
    else
        "Current line is not a heading. Find last heading.
        let l:prevheading = search('^#', 'bnW')
        if l:prevheading == 0
            let l:desireddepth = '1'
            if a:dir == 'b'
                echom "At root"
                return
            endif
        else
            let l:currentdepth = len(split(getline(l:prevheading))[0])
            if a:dir == 'b' && l:currentdepth == 1
                echom "At root"
                return
            endif
            if a:dir == 'b'
                let l:desireddepth = max([l:currentdepth - 1, 1])
            else
                let l:desireddepth = l:currentdepth + 1
            endif
        endif
    endif

    if a:dir == 'b'
        let l:nextheading = 0 "When moving up a level, we don't care where we end up.
        let l:nextdesiredheading = search('^#' . '\{1,' . l:desireddepth . '\}[^#]', 'Wn' . a:dir)
    else
        "When moving down a level, don't reach across a heading of equal or
        "higher depth.
        let l:nextheading = search('^#' . '\{1,' . l:currentdepth . '\}[^#]', 'Wn' . a:dir)
        let l:nextdesiredheading = search('^#' . '\{' . l:desireddepth . ',\}[^#]', 'Wn' . a:dir)
    endif

    "echom 'd:' . l:currentdepth . ' dd:' . l:desireddepth . ' next:' . l:nextheading . ' goal:' . l:nextdesiredheading . ' line:' . l:savelinenum
    if a:dir == '' && l:nextheading < l:nextdesiredheading && l:nextheading != 0
        if l:allowhigher == 1
            exe l:nextheading
            return
        else
            echom "No deeper heading underneath this one"
            exe l:savelinenum
            return
        endif
    endif
    if l:nextdesiredheading == 0
        echom "No headings deeper than this one"
        exe l:savelinenum
        return
    else
        exe l:nextdesiredheading
    endif
endfunction

au FileType markdown nnoremap gl :call MdGoToDeeperHeading('')<CR>
au FileType markdown nnoremap gh :call MdGoToDeeperHeading('b')<CR>

"Automatic closings
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
set pastetoggle=<F3>

"Open split panes to right and bottom
set splitright
"set splitbelow
