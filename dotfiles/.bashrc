# Aliases ----------------------------------------------------
copykeys() {
	ssh $1 mkdir -p .ssh && cat .ssh/id_rsa.pub | ssh $1 'cat >> .ssh/authorized_keys'
}

alias ".."='cd ..'

alias "..."='cd .. && cd ..'

alias playpause='osascript -e "tell application \"iTunes\" to playpause"'

alias sleepnow='osascript -e "tell application \"System Events\" to sleep"'

alias pidof='ps -A | grep'

alias setup='~/src/Bash/setupOrUpdate.sh'

alias update='brew update && brew upgrade && brew cleanup && brew cask cleanup'

alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

alias prm=". ~/src/Bash/prm/prm.sh"

alias mamp-logs='cd /Applications/MAMP/logs/'

alias root='cd /'

alias home='cd $HOME'

alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

alias spotlight='mdfind'

alias autowake='sudo pmset repeat wakeorpoweron MTWRF'

alias cancelwake='sudo pmset repeat cancel'

alias restart='sudo reboot'

alias ql='qlmanage -p'

alias edit='open -e'

alias finder='open .'

alias random='set -- *
length=$#
random_num=$(( $RANDOM % ($length + 1) ))
echo ${!random_num}'

alias rql='set -- *
length=$#
random_num=$(( $RANDOM % ($length + 1) ))
ql  ${!random_num}'

alias back='cd - #'

alias applications='cd /;open Applications/'

alias details='ls -lh'

alias getip='ipconfig getifaddr en1'

alias mount='hdid'

alias dumpdisc='diskutil unmountDisk /dev/disk2s0;dd if=/dev/disk2s0 of=cdname.iso bs=32m'


###   Handy Extract Program

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Colors ----------------------------------------------------------
#export TERM=xterm-color

export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'

export CLICOLOR=1

alias ls='ls -G'  # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
#alias ls='ls --color=auto' # For linux, etc

# ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90'  #LS_COLORS is not supported by the default ls command in OS-X

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'"  # Lists all the colors, uses vars in .bashrc_non-interactive



# Misc -------------------------------------------------------------
export HISTCONTROL=ignoredups
shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# enable history-search (e.g. git "<up/down>" to complete git commands from history...
bind '"\e[B": history-search-forward'
bind '"\e[A": history-search-backward'

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

# Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi



# Prompts ----------------------------------------------------------

# Prompt, looks like:
# ┌─[username@host]-[time date]-[directory]
# └─[$]->
#export PS1="\n\[$Cyan\]┌─[\[$Green\]\u\[$Blue\]@\[$Red\]\h\[$Cyan\]]-[\[$Colour_Off\]\t $(date +'%a %d %b')\[$Cyan\]]-[\[$BYellow\]\w\[$Cyan\]]\n\[$Cyan\]└─[\[$Purple\]\$\[$Cyan\]]->\[$Colour_Off\] "
#export PS2="\[$Cyan\]Secondary->\[$Colour_Off\] "
#export PS3="\[$Cyan\]Select option->\[$Colour_Off\] "
#export PS4="\[$Cyan\]+xtrace $LINENO->\[$Colour_Off\] "

#export PS1="\[${COLOR_CYAN}\]$USER\[${COLOR_GRAY}\]@\[${COLOR_RED}\]$HOSTNAME\[${COLOR_GRAY}\]: \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]"  # Primary prompt with only a path

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\[${COLOR_CYAN}\]$USER\[${COLOR_GRAY}\]@\[${COLOR_RED}\]$HOSTNAME\[${COLOR_GRAY}\]:\[${COLOR_GREEN}\]\W\[$(tput sgr0)\]\[${COLOR_YELLOW}\]\$(parse_git_branch)\[${COLOR_BLUE}\] > \[${COLOR_NC}\]"

# RUN https://github.com/twolfson/sexy-bash-prompt
export PROMPT_USER_COLOR=${COLOR_CYAN}
export PROMPT_PREPOSITION_COLOR=${COLOR_GRAY}
export PROMPT_DEVICE_COLOR=${COLOR_RED}
export PROMPT_DIR_COLOR=${COLOR_GREEN}
export PROMPT_GIT_STATUS_COLOR=${COLOR_YELLOW}
export PROMPT_GIT_PROGRESS_COLOR=${COLOR_YELLOW}
export PROMPT_SYMBOL_COLOR=${COLOR_GRAY}
source ~/.bash_prompt 

# This runs before the prompt and sets the title of the xterm* window.  If you set the title in the prompt
# weird wrapping errors occur on some systems, so this method is superior
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} ${PWD}"; echo -ne "\007"'  # user@host path

export PS2='> '    # Secondary prompt
export PS3='#? '   # Prompt 3
export PS4='+'     # Prompt 4

function xtitle {  # change the title of your xterm* window
  unset PROMPT_COMMAND
  echo -ne "\033]0;$1\007"
}


# Other aliases ----------------------------------------------------
alias ll='ls -hl'
alias la='ls -a'
alias lla='ls -lah'

# Misc
alias g='grep -i'  # Case insensitive grep
alias f='find . -iname'
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias top='top -o cpu'
alias systail='tail -f /var/log/system.log'
alias m='more'
alias df='df -h'

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Editors ----------------------------------------------------------
export EDITOR='subl -w' #Set Sublime Text as user's editor, w is to wait for Sublime Text window to close

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
