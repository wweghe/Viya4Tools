#!/bin/bash
#

# Uncomment the following to enable debugging
# set -x
usage()
{
    echo ""
    echo "getuser-pods : get a list of all SAS Compte pods in a particular Kubernetes namespace with the userid"
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

kubectl -n $namespace get pods -o wide -l 'sas.com/created-by=sas-launcher' -L launcher.sas.com/username -L launcher.sas.com/requested-by-client --sort-by=.metadata.creationTimestamp
