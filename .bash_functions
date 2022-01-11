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

PRE= && [ -z "$TMUX" ] && PRE="$GREEN\u@\h$WHITE:"
DIR="$BLUE\w"
BRANCH="$RED\$(parse_git_branch)"
END=" $GRAY\$$WHITE "
export PS1="$PRE$DIR$BRANCH$END"

# use vim as default editor
export EDITOR=vim

# enforce colors
export TERM="xterm-256color"

# use vim keybinds. this is a terrible idea.
#set -o vi

weather() {
    PLACE=
    VERBOSE='?0'
    for arg in $@; do
        if [ "$arg" == "-v" -o "$arg" == "--verbose" ]; then
            VERBOSE=
        else
            if [ ! -z "$PLACE" ]; then
                PLACE+="_$arg"
            else
                PLACE+="$arg"
            fi
        fi
    done
    curl -s wttr.in/"$PLACE""$VERBOSE"
}

splash_display() {
    paste -d'\t' \
        <(timeout 0.5 curl -s wttr.in?0)     `# Display weather. Skip if it takes longer than 0.5s to retrieve.` \
        <(date +"%H:%M" | figlet -k -f big)  `# Display current time (24h).` \
        | column -tn -c$COLUMNS -s$'\t'       # Put weather and time side by side.
    printf "\n"; date                         # Display full date and time.
    printf "\n"; fortune                      # Display some quote or saying at random.
    printf "\n\n"
}

splash() {
    clear
    tput civis  # Hide cursor.

    splash_display > /tmp/splash

    # Some nice spacing. Try to center the message horizontally and vertical.
    LEN=$(wc -l < /tmp/splash)
    WIDTH=$(wc -L < /tmp/splash)
    OFFSET=$((($COLUMNS - $WIDTH)/2))
    echo $LINES $LEN | awk '{i=$1/2-$2; do {printf "\n"; i--} while (i>0)}'
    if [ $OFFSET -lt 0 ]; then
        cat /tmp/splash
    else
        pr -m -t -o $OFFSET /tmp/splash
    fi
    rm -f /tmp/splash
    read -n1 -s   # Wait for any keypress before displaying prompt.
    tput cnorm    # Restore cursor.
}
