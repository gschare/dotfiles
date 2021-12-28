# vim: filetype=sh
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# include \u and \h for user and hostname
GREEN='\[\e[01;32m\]'
BLUE='\[\e[01;34m\]'
RED='\[\e[01;91m\]'
WHITE='\[\e[00m\]'
GRAY='\[\e[1;30m\]'

PRE="$GREEN\u@\h$WHITE:$BLUE\w"
BRANCH="$RED\$(parse_git_branch)"
END=" $GRAY\$$WHITE "
export PS1="$PRE$BRANCH$END"

# use vim as default editor
export EDITOR=vim

# enforce colors
export TERM="xterm-256color"

# use vim keybinds. this is a terrible idea.
#set -o vi
