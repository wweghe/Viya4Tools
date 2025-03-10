# set -x
usage()
{
    echo ""
    echo "launch-tmux :  Launches tmux with some nice windows for a particular Viya Namespaces"
    echo ""
    echo "  -n <namespace>      Kubernetes namespace you want to report on"
    echo ""
}

if [ "$#" -eq 0 ]; then
    usage
    exit 1
fi

while [ "$#" -gt 0 ]
do
    if [ "$1" = "-n" ]; then
        shift
        namespace="$1"
    else
        shift
    fi
done

NS=$namespace
SessName=viya_watch_$NS
tmux new -s $SessName -d
tmux send-keys -t $SessName "watch -n 5 -d -c \"./GetPodStatus.sh  -n ${NS}\" "  C-m
tmux split-window -v -p 70 -t $SessName
tmux send-keys -t $SessName "watch -n 5   \"./getuserpods.sh  -n ${NS}\" "  C-m
tmux split-window -v -p 70 -t $SessName
tmux split-window -v -p 10 -t $SessName
tmux send-keys -t $SessName "kubectl -n  ${NS} logs -f $(kubectl -n ${NS} get pods | grep read | awk '{ print $1}' ) | jq '.timeStamp, .message' "  C-m


# Attach the tmux configuration to your session.
tmux attach -t $SessName
