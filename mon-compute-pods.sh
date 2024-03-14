while true; do
  kubectl resource-capacity -p -l launcher.sas.com/requested-by-client=sas.studio -c -u -o yaml | yq '.nodes[].pods[] | {"Name": .name, "CPU Util": .cpu.utilization, "Mem Util": .memory.utilization}' | awk '{$1=$1}1' OFS=' ' RS=''
  sleep 1;
done
