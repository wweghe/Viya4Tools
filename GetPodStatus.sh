#!/bin/bash
#

# Uncomment the following to enable debugging
# set -x
usage()
{
    echo ""
    echo "GetPodStatus : get a nice, concise status of all your pods in a particular Kubernetes namespace"
    echo ""
    echo "  -n <namespace>      Kubernetes namespace you want to report on"
    echo "  -t <status>         What status op pods do you want to report on, "All" shows all pods, leave blank for an overview per status"
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
    elif [ "$1" = "-t" ]; then
        shift
        status="$1"
    else
        shift
    fi
    shift
done

if [ "$status" = "" ]; then
  status="Overview"
fi

#echo "Namespace : "$namespace
#echo "Status : "$status

if [ "$status" = "Overview" ] ; then
# Do some fancy AWK to show the whole namespaces overview
# And special thanks to Erwan Granger for the fancy colors
kubectl -n $namespace get pods --no-headers | \
 awk 'BEGIN {TOTAL=0;RUNNING=0;STARTING;ERROR=0;PULLERRORS=0;EVICTED=0;COMPLETED=0;CRASH=0;PENDING=0;INITIALIZING=0;TERMINATING=0} \
 {if ($3 == "Running") \
     {if (substr($2, 1,1) == substr($2, 3,1)) \
          {RUNNING=RUNNING+1;TOTAL=TOTAL+1;                               printf"\033[0;32m.\033[0m"} \
      else {STARTING=STARTING+1;TOTAL=TOTAL+1;                            printf"\033[0;33ms\033[0m"}} \
   else if (($3 == "Error")||($3 == "Init:Error")||($3 == "CreateContainerConfigError")) \
          {ERROR=ERROR+1;TOTAL=TOTAL+1;                                   printf"\033[0;31mE\033[0m"} \
   else if ($3 == "Evicted"){EVICTED= EVICTED+1;TOTAL=TOTAL+1;            printf"\033[0;33me\033[0m"} \
   else if ($3 == "ImagePullBackOff"){PULLERRORS= PULLERRORS+1;TOTAL=TOTAL+1;            printf"\033[0;31mp\033[0m"} \
   else if ($3 == "Completed"){COMPLETED=COMPLETED+1;TOTAL=TOTAL+1;       printf"\033[0;32mC\033[0m"} \
   else if (($3 == "CrashLoopBackOff")||($3 == "Init:CrashLoopBackOff")) \
          {CRASH=CRASH+1;TOTAL=TOTAL+1;                                   printf"\033[0;33mc\033[0m"} \
   else if ($3 == "Pending"){PENDING=PENDING+1;TOTAL=TOTAL+1;             printf"\033[0;33mP\033[0m"} \
   else if (($3 == "PodInitializing")||($3 == "ContainerCreating")||(substr($3,1,4) == "Init")) \
          {INITIALIZING=INITIALIZING+1;TOTAL=TOTAL+1;                     printf"\033[0;33mI\033[0m"} \
   else if ($3 == "Terminating"){TERMINATING=TERMINATING+1;TOTAL=TOTAL+1; printf"\033[0;31mT\033[0m"} \
  else {OTHERS=OTHERS+1;TOTAL=TOTAL+1;                                    printf"\033[0;31mO\033[0m"}} END\
     {printf "\n" ; \
       printf "\033[0;31mOthers (O) ------------\033[0m: %d\n", OTHERS; \
       printf "\033[0;31mPull Error (p) --------\033[0m: %d\n", PULLERRORS; \
       printf "\033[0;31mTerminating (T) -------\033[0m: %d\n", TERMINATING ; \
       printf "\033[0;31mError (E) -------------\033[0m: %d\n", ERROR; \
       printf "\033[0;33mEvicted (e) -----------\033[0m: %d\n", EVICTED; \
       printf "\033[0;33mPending (P) -----------\033[0m: %d\n", PENDING ; \
       printf "\033[0;33mInitializing (I) ------\033[0m: %d\n", INITIALIZING; \
       printf "\033[0;33mCrashLoopBackOff (c) --\033[0m: %d\n", CRASH; \
       printf "\033[0;33mStarting (s) ----------\033[0m: %d\n", STARTING; \
       printf "\033[0;32mCompleted (C) ---------\033[0m: %d\n", COMPLETED; \
       printf "\033[0;32mRunning (.) -----------\033[0m: %d\n", RUNNING; \
       printf "\n"; \
       printf "Total -----------------: %d\n",TOTAL }'
else
# Just reporting on some Statuses
  if [ "$status" = "Starting" ] ; then
    kubectl -n $namespace get pods |grep Running | grep -v -e 1/1 -e 2/2 -e 3/3 -e 4/4 -e 5/5
  elif [ "$status" = "Running" ] ; then
    kubectl -n $namespace get pods |grep Running | grep -v -e 0/1 -e 0/2 -e 0/3 -e 0/4 -e 0/5 -e 1/2 -e 1/3 -e 1/4 -e 1/5 -e 2/3 -e 2/4 -e 2/5 -e 3/4 -e 3/5 -e 4/5
  elif [ "$status" = "Evicted" ] ; then
      kubectl -n $namespace get pods |grep Evicted
  elif [ "$status" = "Others" ] ; then
    kubectl -n $namespace get pods |grep -v -e STATUS -e Running -e Error -e Evicted -e Completed -e CrashLoopBackOff -e Pending -e PodInitializing -e ContainerCreating -e Init -e Terminating
  elif [ "$status" = "Initializing" ] ; then
    kubectl -n $namespace get pods |grep 'PodInitializing\|ContainerCreating\|Init'
  elif [ "$status" = "All" ] ; then
    kubectl -n $namespace get pods
  else
    kubectl -n $namespace get pods |grep $status
  fi
fi
