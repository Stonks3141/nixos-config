set --brace-expand # enable bash-like extended expansion
set --extended-glob # enable recursive pathname expansion
set --no-clobber # prevent redirections from overwriting existing files
set --no-unset # don't implicitly expand non-existent variables to empty strings
set --hist-space # don't save commands starting with a space in history
set --notify-le # print job status update ASAP, but only while line-editing
set --le-no-conv-meta # some terminfo data are broken; meta flags have to be ignored for UTF-8
set --le-predict # enable command line prediction
set --emacs

bindkey --emacs '\^N' beginning-search-forward
bindkey --emacs '\^O' clear-candidates
bindkey --emacs '\^P' beginning-search-backward
bindkey --emacs '\N' complete-next-column
bindkey --emacs '\P' complete-prev-column

sh() { yash --posix "$@"; }
yash() { command yash "$@"; }

# ensure job control works as expected
case $- in (*m*)
    trap - TSTP TTIN TTOU
esac

HISTFILE=~/.local/share/yash/history.txt HISTSIZE=5000

unset _hc _uc _2c

STARSHIP_SESSION_KEY=$(echo "$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM"0000000000000000 | head -c16)
PS1='$(starship prompt --status="$?" --jobs="$(jobs -p | wc -l)")'
PS2='$(starship prompt --continuation)'

PAGER=less
EDITOR=hx
BROWSER=firefox
TERMINAL=foot

PROMPT_COMMAND='zoxide add -- "$(pwd -L)"'

# Jump to a directory using only keywords.
z() {
    if [ "$#" -eq 0 ]; then
        cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "$OLDPWD" ]; then
            cd "$OLDPWD"
        else
            printf 'zoxide: $OLDPWD is not set'
            return 1
        fi
    elif [ "$#" -eq 1 ] && [ -d "$1" ]; then
        cd "$1"
    else
        cd "$(zoxide query --exclude "$(pwd -L)" -- "$@")"
    fi
}

# Jump to a directory using interactive search.
zi() {
    cd "$(zoxide query -i -- "$@")"
}

