# absolute paths are necessary to ensure the symlink succeeds
# -s : create symlink
# -v : verbose
# -f : remove existing destination files
CWD=echo $(pwd)
ln -svf $CWD/.bashrc ~/.bashrc
ln -svf $CWD/.aliases ~/.aliases
ln -svf $CWD/.functions ~/.functions
ln -svf $CWD/.vimrc ~/.vimrc
