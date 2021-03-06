export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
shopt -s histappend

export EDITOR=vim

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

#git prompt from git repository at github
source ~/.git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; __git_ps1 '' '\[\033[0;34m\]\u@\h: \w\\$\[\033[0m\] ' '%s|'"

#git completion from git repository at github
source ~/.git-completion.bash

#Unused PS1 examples
#export PS1='$(__git_ps1 "%s ")\u@\h \w\$ '
#export PS1='$(set_color)\u@\h \w\$ '
#export PS1='\u@\h \w\$ $(set_color)'
#export PS1="\[\033[1;33m\]\u@\h: \w$ \[\033[0m\]"
#export PS1="\u@\h: \w$ "

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

alias ls="ls -lahG"
alias s="git status"
alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias pu="cd && clear"

bupdate() {
    for cmd in brew\ {update,doctor,upgrade,cleanup,prune}
    do
        echo "--> $cmd" && $cmd || return 1
    done
}

timer() {
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
  echo "    ptimer2 takes three input parameters: time, message and button text.
    Example usage: ptimer2 2 \"Time for a break!\" \"Yes, that is a good idea\"
    sets a two minutes timer with message \"Time for a break!\" with button \"Yes, that is a goo idea.\""
else
echo "timer set for $1 minutes with the message \"$2\" and button \"$3\""
    exec 3>&1
    mkdir -p ~/.bash_profile_logs
    exec 1>>~/.bash_profile_logs/timer_log_file
    (sleep_and_display $1 "$2" "$3" "Time's up!" &)
    exec 1>&3
    exec 3>&-
fi
}

#For finding files
function f() {
    find . -iname "$1"
}

#For finding text in files
function fif() {
    echo "args <path> <depth> <filename> <string>"
    if [ "$#" -eq 4 ]; then   
        find $1 -maxdepth $2 -type f -name "$3" -print0 | xargs -0 grep "$4"
    else
        echo "Wrong number of arguments"
    fi
}

export JAVA_HOME="$(/usr/libexec/java_home)"
