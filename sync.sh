#!/bin/sh
# absolute paths are necessary to ensure the symlink succeeds
# -s : create symlink
# -v : verbose
CWD="$(pwd)"
ln -svi $CWD/.bashrc ~/.bashrc
ln -svi $CWD/.bash_aliases ~/.bash_aliases
ln -svi $CWD/.bash_functions ~/.bash_functions
ln -svi $CWD/.vimrc ~/.vimrc
ln -svi $CWD/.tmux.conf ~/.tmux.conf
