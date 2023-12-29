# vim: filetype=sh
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# include \u and \h for user and hostname
GREEN='\[\e[01;32m\]'
BLUE='\[\e[01;34m\]'
RED='\[\e[01;91m\]'
WHITE='\[\e[00m\]'
YELLOW='\[\e[01;37m\]'

PRE= && [ -z "$TMUX" ] && PRE="$GREEN\u@\h$WHITE:"
DIR="$BLUE\w"
BRANCH="$RED\$(parse_git_branch)"
END=" $YELLOW\$$WHITE "
export PS1="$PRE$DIR$BRANCH$END"

# use vim as default editor
export EDITOR=vim

# enforce colors
export TERM="xterm-256color"

# use vim keybinds. this is a terrible idea.
#set -o vi

# git aliases
git config --global alias.root 'rev-parse --show-toplevel'

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

openssm() {
    MNGRLOC=~/My\ Drive/manager.7z
    7z x -bb0 "$MNGRLOC" -p$PWDMNGPWD -y -o/tmp > /dev/null
    if [ $? -eq 0 ]
    then
        $EDITOR '/tmp/passwords.txt' && 7z u -bb0 "$MNGRLOC" '/tmp/passwords.txt' -p$PWDMNGPWD > /dev/null
        if [ $? -eq 0 ]
        then
            rm -f '/tmp/passwords.txt'
        else
            echo "An error occurred while adding the file back to archive.\n /tmp/passwords.txt is left for recovery." >&2
            return 2
        fi
    else
        echo "An error occurred while opening the archive." >&2
        return 2
    fi
}

wordle() {
    cd $DEVDIR/github/wordle && ./wordle
}

function theme {
    echo -ne "\033]50;SetProfile=$1\a"
    export ITERM_PROFILE=$1
    if [ $1 = "dark" ]; then
        if [ ! -z "$TMUX" ]; then
            echo "in tmux, switch to dark"
            tmux set-environment ITERM_PROFILE dark
        fi
    else
        if [ ! -z "$TMUX" ]; then
            echo "in tmux, switch to light"
            tmux set-environment ITERM_PROFILE light
        fi
    fi
}

nchttp() {
    local in="$(cat -)"
    (
    echo "HTTP/1.0 200 OK";
    echo;
    echo "$in"
    ) | nc -l localhost $1
}

toss() {
    TS=$(date -u +"%y-%m-%d_%H-%M-%SZ")
    mv -i $1 "$TRASHDIR"/"$TS-$1"
}

timer() {
  IFS=: # separate by ':' character
  set -- $* # set positional variables to the words of the argument (separated by ':')
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} )) # calculate time in seconds

  len=$secs
  lens="$((len%60))"
  lenm="$(((len/60)%60))"
  lenh="$((len/3600))"

  plurals=$([ "$lens" -ne '1' ] && echo "s" || echo "")
  pluralm=$([ "$lenm" -ne '1' ] && echo "s" || echo "")
  pluralh=$([ "$lenh" -ne '1' ] && echo "s" || echo "")

#  if [ "$lenh" -eq '0' -a "$lenm" -eq '0' ]
#  then
#      say -v Karen -r 200 "Timer started for $lens second$plurals."
#  elif [ "$lenh" -eq '0' ]
#  then
#      say -v Karen -r 200 "Timer started for $lenm minute$pluralm and $lens second$plurals."
#  else
#      say -v Karen -r 200 "Timer started for $lenh hour$pluralh $lenm minute$pluralm and $lens second$plurals."
#  fi

  while [ $secs -gt 0 ]
  do
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=0 #$(( $secs - 1 ))
    sleep 1
  done
  for ((i=0;i<3;i++))
  do
      printf "\a"
      sleep 0.15
  done
  echo

  rate=250
  voice="Karen"

  if [ "$lenh" -eq '0' -a "$lenm" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lens second$plurals is finished."
  elif [ "$lenh" -eq '0' -a "$lens" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lenm minute$pluralm is finished."
  elif [ "$lenm" -eq '0' -a "$lens" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lenh hour$pluralh is finished."
  elif [ "$lens" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lenh hour$pluralh and $lenm minute$pluralm is finished."
  elif [ "$lenm" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lenh hour$pluralh and $lens second$plurals is finished."
  elif [ "$lenh" -eq '0' ]
  then
      say -v "$voice" -r "$rate" "Timer for $lenm minute$pluralm and $lens second$plurals is finished."
  else
      say -v "$voice" -r "$rate" "Timer for $lenh hour$pluralh $lenm minute$pluralm and $lens second$plurals is finished."
  fi
}

stopwatch() {
  secs=0
  while true
  do
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs + 1 ))
    sleep 1
  done
  echo
}

search () {
    strip-note-context () {
        cut -d'|' -f1 | tr -d ' '
    }
    add-note-context () {
        while IFS='$\n' read -r in; do
            echo "$in | $(grep -v '<meta.*>' $in | head -c 140 | tr '\n' ' ' | tr -d '|') | $(head -40 $in | tr '\n' ' ' | tr -d '|')"
        done
    }
    # ripgrep fuzzy find. Given regex term to search.
    # $1: the directory or file to run search in. By default, use current directory.
    # $2: regex term. Default match everything ('.').
    print_usage () { echo "Usage: $0 [path] [regex]" 1>&2; }
    if [ -z $1 ]; then
        DIR='.'
    else
        DIR="$1"
    fi
    if [ -z $2 ]; then
        INITIAL_QUERY='.'
    else
        INITIAL_QUERY="$2"
    fi

    # special behavior options
    [ -z "$DISPLAY_DIR" ] && DISPLAY_DIR=$DIR
    [ -z "$REVERSE" ] && REVERSE="false"
    if [ $REVERSE = "true" ]; then
        DIRECTION="r"
    else
        DIRECTION=""
    fi

    RG_PREFIX='rg --column --line-number --no-heading --color=always --smart-case'
    if [ ! -z "$RECENTS" ]; then
        #DEF_CMD="echo \"$(printf "$RECENTS"; $RG_PREFIX -l --sort$DIRECTION path $INITIAL_QUERY $DIR | add-note-context)\""
        #printf "$DEF_CMD" >&2
        #sh -c "echo $DEF_CMD" >&2
        true
    else
        #DEF_CMD="echo \"$($RG_PREFIX -l --sort$DIRECTION path $INITIAL_QUERY $DIR | add-note-context)\""
        true
    fi
    ALL_NOTES="$($RG_PREFIX -l --sort$DIRECTION path $INITIAL_QUERY $DIR)"
    #(printf "$RECENTS"; ($RG_PREFIX -l --sort$DIRECTION path $INITIAL_QUERY $DIR | add-note-context)) >&2
    # Idea: implement a key that changes the environment to toggle between
    # by most recently opened, most recently modified, and alphabetical.
    # Problem: folders are fucked anyway in terms of path sort.
    IFS='$\n' out=("$(
            (printf "$RECENTS"; printf "$ALL_NOTES") |
            fzf --ansi \
                --disabled \
                --prompt "$DISPLAY_DIR> " \
                --expect=ctrl-o,ctrl-r,ctrl-t,ctrl-s,ctrl-v,ctrl-x \
                --layout=reverse \
                --preview-window=down \
                --margin=2%,2%,2%,2% \
                --preview="$RG_PREFIX --context 1 {q} {} --sort$DIRECTION path"
                )")
 #--bind "change:reload:[ -z {q} ] && printf \"$RECENTS\"; $RG_PREFIX -l {q} --sort$DIRECTION path $DIR | add-note-context || true" \
 #--preview="echo {3} | $RG_PREFIX --context 1 {q} --sort$DIRECTION path"
                #--preview='echo {3}'
                #--delimiter='|' \
                #--with-nth=1,2 \
    ret_code=$?
    cd "$CWD"
    echo "${out[@]}"
    if [[ $ret_code -ne 0 ]]; then
        return $ret_code
    fi
}

new_note_name() {
   D="$(date -u +"$NOTESDIR/\%y.\%m.\%d-\%H.\%M.md")"
   i=1
   while [[ -f "$D" ]]; do
       D="$(date -u -j -v +"$i"m +"$NOTESDIR/\%y.\%m.\%d-\%H.\%M.md")"
       i=$(($i+1))
   done
   echo "$D"
}

note() {
    # [Epic] TODO(gts): rewrite in Rust

    print_usage () { echo -e "Usage: note [open|new|app|home|host]" 1>&2; }
    add_recent () {
        if [ ! -f $NOTESDIR/.notes_history ]; then
            touch $NOTESDIR/.notes_history
        fi
        python3 -c """
NUM_RECENT = 10
with open('$NOTESDIR/.notes_history', 'r') as fp:
    recents = fp.readlines()
recents = [r.rstrip('\n') for r in recents]

try:
    i = recents.index('$1')
    recents.pop(i)
except ValueError:
    pass
recents.insert(0, '$1')

with open('$NOTESDIR/.notes_history', 'w') as fp:
    s = '\n'.join(recents[:NUM_RECENT])
    fp.write(s)
    fp.write('\n')
        """
    }
    star_note () {
        if [ ! -f $NOTESDIR/.starred_notes ]; then
            touch $NOTESDIR/.starred_notes
        fi
        python3 -c """
with open('$NOTESDIR/.starred_notes', 'r') as fp:
    stars = fp.readlines()
stars = [s.rstrip('\n') for s in stars]
if '$1' in stars:
    stars.remove('$1')
    print('Unstarring %s' % '$1')
else:
    stars.append('$1')
    print('Starring %s' % '$1')
with open('$NOTESDIR/.starred_notes', 'w') as fp:
    s = '\n'.join(stars)
    fp.write(s)
    fp.write('\n')
        """
    }
    prompt_link () {
        out=$(CWD=$CWD REVERSE=true DISPLAY_DIR="Link to"
              RECENTS="$([ -f $NOTESDIR/.starred_notes ] &&
                           printf "\033[1;33m" &&
                           cat $NOTESDIR/.starred_notes ;
                           #[ -f $NOTESDIR/.notes_history ] &&
                           printf "\033[1;34m" &&
                           #cat $NOTESDIR/.notes_history &&
                           ls -ut1 | head -20 &&
                           printf "\033[0m")"
              search $HOME/notes )
        ret_code=$?
        if [[ $ret_code -ne 0 ]]; then
            cd "$CWD"
            return $ret_code
        fi
        key=$(head -1 <<< $out)
        files=$(tail -n +2 <<< $out)
        echo $files
    }
    link_note () {
        src="$1"
        for dst in $2;
        do
            ln=1
            while true
            do
                l="$(sed -n "$ln"p $dst)"
                if [[ $l == "<meta"* ]]; then
                    ln=$(($ln + 1))
                    continue
                else
                    break
                fi
            done
            echo "[$l]($dst)" >> "$src"
        done
    }
    update_tags () {
        rg "<meta tag=\"(.*)\">" -I -o -r '$1' $NOTESDIR | cut -d':' -f2 | sed 's/ /\n/g' | sort | uniq > $NOTESDIR/.tags
    }
    tag_note () {
        files=$1
        tag_name="$2"
        # This is dumb tagging.
        for fp in $files; do
            echo -e "<meta tag=\"$tag_name\">\n$(cat "$fp")" > "$fp"
        done
        update_tags
    }
    add-note-context () {
        while IFS='$\n' read -r in; do
            echo "$in | $(grep -v '<meta.*>' $in | head -c 140 | tr '\n' ' ' | tr -d '|') | $(head -40 $in | tr '\n' ' ' | tr -d '|')"
        done
    }
    strip-note-context () {
        cut -d'|' -f1 | tr -d ' '
    }
    # No point in searching the filenames since they contain no useful data.
    # Instead, filter down using ripgrep on change.
    CWD=$(pwd)
    cd $NOTESDIR
    if [[ $1 = "open" || -z $1 ]]; then
        out=$(CWD=$CWD REVERSE=true DISPLAY_DIR="Notes"
              RECENTS="$([ -f $NOTESDIR/.starred_notes ] &&
                           printf "\033[1;33m" &&
                           (cat $NOTESDIR/.starred_notes);
                           #[ -f $NOTESDIR/.notes_history ] &&
                           printf "\033[1;34m" &&
                           (ls -ut1 | head -20) &&
                           #cat $NOTESDIR/.notes_history &&
                           printf "\033[0m")"
              search)
        ret_code=$?
        if [[ $ret_code -ne 0 ]]; then
            cd "$CWD"
            return $ret_code
        fi
        key=$(head -1 <<< $out)
        files=$((tail -n +2 <<< $out))
            # TODO: can we do string processing so the thing listed in fzf
            # is different than the thing we open? so first few lines are displayed, e.g.
            # using a clever algorithm
            # ^^ then I can finally use this for other stuff, if we have
            # loosely coupled metadata.

            # add (proper) tagging support. For notes, just keep it in file.
            # Notes need no metadata! The only information at all relevant
            # is their filepath (folder and filename) and contents.
            # The cached first lines thing is just for nice display and can
            # be regenerated using the filepath and contents.
        if [[ -n "$files" ]]; then
            if [ "$key" = "ctrl-o" ]; then      # open
                open $files
                add_recent $files
            elif [ "$key" = "ctrl-r" ]; then    # new
                TS=$(date -u +"%y.%m.%d-%H.%M")
                ${EDITOR:-vim} "$NOTESDIR/$TS.md"
                [ -f "$NOTESDIR/$TS.md" ] && add_recent "$TS.md"
            elif [ "$key" = "ctrl-v" ]; then    # edit/view
                ${EDITOR:-vim} $files
                add_recent $files
            elif [ "$key" = "ctrl-s" ]; then    # star
                for fp in $files; do
                    star_note $fp
                done
            elif [ "$key" = "ctrl-x" ]; then    # link
                for src in $files; do
                    dst=$(prompt_link)
                    link_note $src $dst
                done
            elif [ "$key" = "ctrl-t" ]; then    # tag
                for fp in $files; do
                    #tput smcup
                    printf "Tag to add: "
                    read tag_name
                    #tput rmcup
                    tag_note $fp "$tag_name"
                done
            else                                # print
                echo $files
            fi
        fi
    elif [[ $1 = "new" ]]; then
        TS=$(date -u +"%y.%m.%d-%H.%M")
        ${EDITOR:-vim} "$NOTESDIR/$TS.md"
        [ -f "$TS.md" ] && add_recent "$TS.md"
    elif [[ $1 = "app" ]]; then
        note open && note app
    elif [[ $1 = "home" ]]; then
        ${EDITOR:-vim} "$NOTESDIR/home.md"
        add_recent "home.md"
    elif [[ $1 = "host" ]]; then
        files=$(note open)
        (for fp in $files; do
            cat "$fp"
            echo
            echo '---'
            echo
        done) | pandoc -f gfm -s | nchttp 3000
    elif [[ $1 = "update-tags" ]]; then
        update_tags
    else
        print_usage
    fi
    cd "$CWD"
}

scratch() {
    INITIAL_QUERY=""
    if [[ $1 = "open" || -z $1 ]]; then
        out=$(DISPLAY_DIR="Scratch" search $SCRATCHDIR)
        key=$(head -1 <<< $out)
        files=$(tail -n +2 <<< $out)
        if [[ -n "$files" ]]; then
            if [ "$key" = "ctrl-t" ]; then
                open $files
            elif [ "$key" = "ctrl-r" ]; then
                CWD=$(pwd)
                cd $SCRATCHDIR
                ${EDITOR:-vim}
                cd "$CWD"
            else
                ${EDITOR:-vim} $files
            fi
        fi
    else
        CWD=$(pwd)
        cd $SCRATCHDIR
        ${EDITOR:-vim} $1
        cd "$CWD"
    fi
}

text() {
    cat - | (echo "[hai :3]" ; sed -u -e "s/\(.*\)/[gigi] \1$(echo -e '\07')/"; echo "[gigi has left the chatroom]") | nc 192.168.0.127 17001
}

# fzf options
export FZF_DEFAULT_COMMAND="fd"
export FZF_DEFAULT_OPTS="
    --multi
    --layout=reverse
    --marker='*'
    --margin=10%,10%,10%,10%
    --bind 'tab:toggle'
    --bind 'ctrl-i:toggle'
    --preview-window=wrap
    --cycle"
    #--bind 'ctrl-g:toggle-preview'
    #--bind 'ctrl-p:preview(echo {})'
    # bindings:
    # C-i: toggle
    # Tab: toggle and move down
    # S-Tab: toggle and move up
    # C-j: down
    # C-k: up
    # C-n: down
    # C-a: beginning of line
    # C-e: end of line
    # M-d: delete word ahead
    # C-w: delete word behind
    # C-m: accept
    # Ent: accept
    # C-p: preview
    # C-u: delete line behind
    # C-y: yank
    # C-o: open in glow
    # C-l: refresh screen
    # C-h: delete
    # C-c: exit(130)
    # Esc: exit(130)
    # C-g: quit
    # C-q: quit
    # C-d: delete char/abort if query is empty
    # C-b: back one char
    # C-f: ahead one char
    # M-f: ahead one word
    # M-b: behind one word
    # pgup: screen up
    # pgdn: screen down
    #
    # unused:
    # C-t
    # C-r
    # C-v
    # C-o
    # C-s
    # C-x
    # C-z
    # C-6/C-^
    # C-]
    # C-\
    # C-/
    # C-space
    # f[1-12]
    # alt-*
    # ctrl-alt-*

