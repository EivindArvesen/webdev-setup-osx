#!/usr/bin/env bash

# Prerequisite: Tmux-indexing starts at one for everything...

SESSION="WebDev"
LOGS="/Applications/MAMP/logs"

if [[ $(tmux list-clients -t $SESSION) ]]; then
    exit
else
    CMD_1="cd $LOGS && tail -f apache_error.log'"
    CMD_2="cd $LOGS && tail -f mysql_error_log.err'"
    CMD_3="cd $LOGS && tail -f php_error.log'"
    CMD_4="echo 'Do stuff here.'"

    tmux new -s $SESSION -n ADNI -d && tmux split-window -h -p 50 -t $SESSION && tmux split-window -v -p 50 -t $SESSION:1.1 && tmux split-window -v -p 50 -t $SESSION:1.2 && tmux send-keys -t $SESSION:1.1 "clear && $CMD_1" C-m && tmux send-keys -t $SESSION:1.2 "clear && $CMD_2" C-m && tmux send-keys -t $SESSION:1.3 "clear && $CMD_3" C-m && tmux send-keys -t $SESSION:1.4 "clear && $CMD_4" C-m && tmux attach -t $SESSION:1 && exit || tmux attach -t $SESSION && exit
fi
