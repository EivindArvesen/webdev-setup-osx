# Path ------------------------------------------------------------
export PATH=${PATH}:/usr/local/bin
export PATH=${PATH}:/usr/local/sbin

# Specify your defaults in this environment variable
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [ -d ~/bin ]; then
	export PATH=:~/bin:$PATH  # add your bin folder to the path, if you have it.  It's a good place to add all your scripts
fi

# Set locale (Rectifies bugs with certain python packages...)
export LANG="no_NO.UTF-8"
export LC_COLLATE="no_NO.UTF-8"
export LC_CTYPE="no_NO.UTF-8"
export LC_MESSAGES="no_NO.UTF-8"
export LC_MONETARY="no_NO.UTF-8"
export LC_NUMERIC="no_NO.UTF-8"
export LC_TIME="no_NO.UTF-8"
export LC_ALL=

export PYTHONPATH="${PYTHONPATH}:$HOME/src/Python/" # User Python scripts
export PATH=/usr/local/share/npm/bin:$PATH # Node stuff...
export PATH=/usr/local/lib/node_modules/grunt/bin:$PATH # Grunt

export WWW_HOME="http://www.google.com"

export GIT_EDITOR="subl --wait --new-window"

# Load in .bashrc -------------------------------------------------
source ~/.bashrc

alias fuck='eval $(thefuck $(fc -ln -1))' # alias for "thefuck" software
# You can use whatever you want as an alias, like for Mondays:
alias FUCK='fuck'


# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X,
# or create a new tab in iTerm) the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started
# (when you run "bash" from inside a shell, or when you start a shell in
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed,
# in this order:
#     bashrc
#     .bashrc

### MUST BE DONE LAST!
# Setup tmux (attach, create or ignore session)
#if [ `which tmux 2> /dev/null` -a -z "$TMUX" ]; then
#    sh $HOME/src/Bash/tmuxAuto.sh
#fi
