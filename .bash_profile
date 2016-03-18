export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
shopt -s histappend

export EDITOR=vim

if [ -f $(brew --prefix)/etc/bash_completion ]; 
then
    . $(brew --prefix)/etc/bash_completion
fi

#git prompt from git repository at github
source ~/Utilities/git-prompt.sh
#source ~/Utilities/git-prompt-addition
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export PROMPT_COMMAND="history -n; history -w; history -c; history -r; __git_ps1 '' '\[\033[0;34m\]\u@\h: \w\\$\[\033[0m\] ' '%s|'"

#git completion from git repository at github
source ~/Utilities/git-completion.bash

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
alias yt="open https://www.youtube.com/"
alias gh="open https://github.com/"
alias glh="open http://localhost:8080/"
alias rlh="open http://localhost:3000/"
alias presisu="memcached -d && mysql.server start && (cd ~/Objects/sisu ; rake ts:start)"
alias myip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias pu="cd && clear"

upgrade_casks() {
    old_ifs=$IFS
    IFS=$'\n'
    for cask in $(brew cask list)
    do
        caskname=$(awk '{ print $1 }' <<< $cask)
        if grep '(!)$' <<< $cask >/dev/null
        then
            echo "warning: the installed cask $caskname seems to be" \
                "unavailable in homebrew-cask, has it been renamed?" && continue
        fi
        if brew cask info $cask | grep -qiF 'Not installed'
        then
            echo "--> upgrading cask $cask"
            brew cask uninstall $cask
            brew cask install $cask
        fi
    done
    brew cask cleanup
    IFS=$old_ifs
}

pupdate() {
    bupdate
    upgrade_casks
}

bupdate() {
    for action in update doctor 'upgrade --all' cleanup
    do
        echo "--> brew $action" && brew $action
    done
}

ptimer() {
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

sleep_and_display(){
    sleep $(($1 * 60))
    /usr/bin/osascript <<-EOF
        display dialog "$2" buttons {"$3"} default button "$3" with title "$4"
EOF
}

#Joels git prompt
#source ~/Utilities/git_prompt
#export PS1="\$(git_prompt)"$PS1

#export DYLD_LIBRARY_PATH=/usr/local/Cellar/mysql/5.6.24/lib/
#launchctl setenv DYLD_LIBRARY_PATH /usr/local/Cellar/mysql/5.6.24/lib/


