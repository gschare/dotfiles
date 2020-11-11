"No compatibility mode
set nocompatible

"Fix problem where vim starts in REPLACE mode
"See https://www.reddit.com/r/bashonubuntuonwindows/comments/ijys54/has_anyone_else_started_seeing_vim_open_in/
set t_u7=

"Show command keystrokes
set showcmd

"Line numbers
set number

"Tab settings
set shiftwidth=4
set softtabstop=0
set tabstop=4
set autoindent
set smartindent
set expandtab

autocmd FileType make setlocal noexpandtab
autocmd FileType python setlocal tabstop=4 autoindent smartindent

" My settings when editing *.txt files
"   - automatically indent lines according to previous lines
"   - replace tab with 8 spaces
"   - when I hit tab key, move 2 spaces instead of 8
"   - wrap text if I go longer than 76 columns
"   - check spelling
autocmd FileType text setlocal autoindent expandtab softtabstop=2 textwidth=76 spell spelllang=en_us

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
syntax on
filetype plugin indent on

"Search highlighting WHILE search but not after
set incsearch

"Search highlighting AFTER search
set hlsearch

"Allow mouse scrolling and such
set mouse=a

"Color scheme
set termguicolors
autocmd vimenter * colorscheme gruvbox
autocmd vimenter * let g:airline_theme='gruvbox'
autocmd vimenter * set bg=dark
autocmd vimenter * highlight Normal ctermbg=NONE guibg=NONE

"Turn off mode indicator (airline is better)
set noshowmode

"Custom keybindings
noremap <C-Up> 5k
noremap <C-Down> 5j
"Tab always indents, Shift-Tab always deindents
inoremap <S-Tab> <C-D>
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >
vnoremap <S-Tab> <
"Reload screen also clears previous search
nnoremap <C-l> :nohlsearch<CR><C-l>
"Shift-Space in insert mode enters normal mode
"inoremap <S-Space> <Esc>
"Shift-Space in normal mode enters insert mode
"nnoremap <S-Space> i

"Open split panes to right and bottom
set splitright
set splitbelow
