#!/usr/bin/env bash

# Prerequisite: Tmux-indexing starts at one for everything...

SESSION="WebDev"

if [[ $(tmux list-clients -t $SESSION) ]]; then
    exit
else
    # Local
    NAME_1="Local"
    CMD_1_1="cd /Applications/MAMP/logs && tail -f php_error.log"
    CMD_1_2="cd $HOME/src/Sites/ && ls"
    CMD_1_3="sudo vim /etc/hosts"

    # Mozart
    NAME_2="Mozart"
    CMD_2_1="ssh -t mozart sudo tail -f /var/log/apache2/error.log"
    CMD_2_5="ssh -t mozart \"cd /var/data/risp/xml/Green/Test && exec bash -l\""
    CMD_2_3="ssh -t mozart \"cd /var/data/risp/xml-drafts/green_internal/Test/Test/Playground && exec bash -l\""
    CMD_2_4="ssh -t mozart \"cd sites/risp && ls && git status && exec bash -l\""
    CMD_2_2="ssh -t mozart \"cd /var/spool/deployment/aquarius/live/sites/risp && sudo su && exec bash -l\""

    # Imbrium
    NAME_3="Imbrium"
    CMD_3_1="ssh -t imbrium 'sudo bash -c \"tail -f /var/log/apache2/error.log\"'"
    CMD_3_2="ssh -t imbrium \"cd sites/moses/ && exec bash -l\""

    # Temp
    NAME_4="Temp"
    CMD_4_1="ssh eivindar@mpublish.no"
    CMD_4_2="which dig && which whois"


    tmux new -s $SESSION -d &&


    tmux rename-window -t $SESSION:1 $NAME_1 &&
    tmux split-window -h -p 50 -t $SESSION &&
    tmux split-window -v -p 50 -t $SESSION:1.1 &&

    tmux send-keys -t $SESSION:1.1 "clear && $CMD_1_1" C-m &&
    tmux send-keys -t $SESSION:1.2 "clear && $CMD_1_2" C-m &&
    tmux send-keys -t $SESSION:1.3 "clear && $CMD_1_3" C-m &&


    tmux new-window -t $SESSION &&
    tmux rename-window -t $SESSION:2 $NAME_2 &&

    tmux split-window -h -p 50 -t $SESSION &&
    tmux split-window -v -p 50 -t $SESSION:2.1 &&
    tmux split-window -v -p 50 -t $SESSION:2.2 &&
    tmux split-window -v -p 50 -t $SESSION:2.3 &&

    tmux send-keys -t $SESSION:2.1 "clear && $CMD_2_1" C-m &&
    tmux send-keys -t $SESSION:2.2 "clear && $CMD_2_2" C-m &&
    tmux send-keys -t $SESSION:2.3 "clear && $CMD_2_3" C-m &&
    tmux send-keys -t $SESSION:2.4 "clear && $CMD_2_4" C-m &&
    tmux send-keys -t $SESSION:2.5 "clear && $CMD_2_5" C-m &&


    tmux new-window -t $SESSION &&
    tmux rename-window -t $SESSION:3 $NAME_3 &&

    tmux split-window -h -p 50 -t $SESSION &&

    tmux send-keys -t $SESSION:3.1 "clear && $CMD_3_1" C-m &&
    tmux send-keys -t $SESSION:3.2 "clear && $CMD_3_2" C-m &&


    tmux new-window -t $SESSION &&
    tmux rename-window -t $SESSION:4 $NAME_4 &&

    tmux split-window -h -p 50 -t $SESSION &&
    tmux split-window -v -p 50 -t $SESSION:4.1 &&
    tmux split-window -v -p 50 -t $SESSION:4.2 &&

    tmux send-keys -t $SESSION:4.1 "clear && $CMD_4_1" C-m &&
    tmux send-keys -t $SESSION:4.3 "clear && $CMD_4_2" C-m &&
    tmux clock-mode -t $SESSION:4.2 &&


    tmux attach -t $SESSION:4.4 &&
    exit || tmux attach -t $SESSION && exit
fi
