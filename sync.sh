# absolute paths are necessary to ensure the symlink succeeds
# -s : create symlink
# -v : verbose
# -f : remove existing destination files
ln -svf /mnt/c/code/github/dotfiles/.bashrc ~/.bashrc
ln -svf /mnt/c/code/github/dotfiles/.aliases ~/.aliases
ln -svf /mnt/c/code/github/dotfiles/.functions ~/.functions
ln -svf /mnt/c/code/github/dotfiles/.vimrc ~/.vimrc
