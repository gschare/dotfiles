# vim: filetype=sh
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
# include \u and \h for user and hostname
export PS1="/ \[\e[01;34m\]\w\[\e[00m\]\n\\ \[\e[01;91m\]\$(parse_git_branch)\[\e[1;30m\]$\[\e[00m\] "

# use vim as default editor
export EDITOR=vim

# enforce colors
export TERM="xterm-256color"

# use vim keybinds. this is a terrible idea.
#set -o vi
