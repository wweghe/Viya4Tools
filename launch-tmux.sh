NS=viya4
SessName=viya_watch
tmux new -s $SessName -d
tmux send-keys -t $SessName "watch -n 5 -d -c \"$HOME/bin/GetPodStatus.sh  -n ${NS}\" "  C-m
tmux split-window -v -p 70 -t $SessName
tmux send-keys -t $SessName "watch -n 5  \"$HOME/bin/getuserpods.sh  -n ${NS}\" "  C-m
tmux split-window -v -p 70 -t $SessName
tmux split-window -v -p 10 -t $SessName
tmux send-keys -t $SessName "kubectl -n  ${NS} logs -f $(kubectl -n ${NS} get pods | grep read | awk '{ print $1}' ) | jq '.timeStamp, .message' "  C-m


# Attach the tmux configuration to your session.
tmux attach -t $SessName
