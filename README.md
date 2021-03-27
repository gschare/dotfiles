These are my dotfiles.
They are here in order to make it easy for me to keep my Linux configuration consistent across machines.

# Software to install
In addition to these config files, the critical pieces of software I use are:
- git
- tmux
- vim (should be pre-installed on most systems)

# Programming languages and tools
Not including stuff that should be pre-installed like `make`.
- awscli: mandatory if you work with AWS
- gcc & g++ (& mingw if you work with Windows)
- ghc & haskell-platform
- hindent: Haskell prettier
- nodejs & yarn
- perl
- python3
- racket
- sqlite3
- valgrind

# Some other random cool software to have
These are just nice GNU things, generally.
- ffmpeg: if you do anything with sound
- imagemagick: I deeply love this software
- jing: xml validation
- pandoc: **highly** recommended, especially for LaTeXers and webdevs.
- rclone & rsync: critical for cloud computing
- unzip & gzip
- xsltproc: for testing xslt templates

# Vim details
My vim configuration, in addition to my .vimrc, involves several lightweight packages and some slight tinkering in the `after/` directory.
Here are what I use:
- `after/syntax/`
  - `scheme.vim`: a simple addition to Scheme syntax highlighting for to add `λ` and `nil` as keywords.
      ```vimscript
      syn keyword schemeSyntax λ
      syn keyword schemeSyntax nil
      ```
      The Unicode character `λ` is `\u03bb`.
- `pack/dist/start/`
  - gruvbox
    - I have altered the Haskell colors in Gruvbox directly. These are my personal choices. The Haskell portion of the `gruvbox.vim` is available in this repo.
  - haskell-vim
  - lhaskell-vim (literate Haskell)
  - typescript-vim
  - vim-airline
  - vim-airline-themes
  - vim-closetag
  - vim-jsx-typescript (React syntax highlighting)

These are all fairly self-explanatory.

# htop
I do have htop configurations but I figure it's not important or complex enough to warrant including here. Also it's not a very stable configuration file.

# A note on colors
My terminal and vim colors are terribly hacked together. I got them to a nice stable situation that pleases my eye, but there is little chance this will work at all, let alone look good, on anything but a Windows 10 computer running Windows Subsystem for Linux through Windows Terminal.
As you can see in my configuration, I'm using Gruvbox themes for vim and Windows Terminal but it's pretty janky.
