# Viya4Tools

## GetPodStatus

The script `GetPodStatus.sh` gives you a nice, concise, and easy way to get the Status of all your pods in a particular Kubernetes namespace.  
It complements your typical `"kubectl -n <namespace> get pods"` with some basic "awk" processing to give you this kind of overview :

```shell
./GetPodStatus.sh -n viya401
I..I.II.I....s..I.IIII...sII.IIC.IIIs..II.I.s.Iss.IIsIsIs..sI......Csss.sII.sI.ss...II....C.III..II....II.II.IIsIIsIIIIIIIII
Others (O) ------------: 0
Pull Error (p) --------: 0
Terminating (T) -------: 0
Error (E) -------------: 0
Evicted (e) -----------: 0
Pending (P) -----------: 0
Initializing (I) ------: 53
CrashLoopBackOff (c) --: 0
Starting (s) ----------: 19
Completed (C) ---------: 3
Running (.) -----------: 49

Total -----------------: 124
```
The long line on top gives you a "graphical" representation of the status of your pods, in alphabetical order, with every character representing the status of your pod.  
Most of the statuses are obvious, but some attention to :  
- Starting : means the pod is running, but not all the containers in the pod are up (e.g. Running 0/1)
- Initializing is a grouping of ContainerCreating, PodInitializing, Init:0/1, Init:0/2, Init:1/2
- Others means it's none of the above ;-)

And - if all goes well - after a while it could look like this : 
```shell
./GetPodStatus.sh -n viya401
C...............................C....................................C......................C.................................
Others (O) ------------: 0
Pull Error (p) --------: 0
Terminating (T) -------: 0
Error (E) -------------: 0
Evicted (e) -----------: 0
Pending (P) -----------: 0
Initializing (I) ------: 0
CrashLoopBackOff (c) --: 0
Starting (s) ----------: 0
Completed (C) ---------: 4
Running (.) -----------: 122

Total -----------------: 126
```

You can also use the `-t` parameter to pass on a particular type of Status you want to report on : 
```shell
./GetPodStatus.sh -n viya401 -t Completed
backrest-backup-sas-crunchy-data-postgres-6pc8x                   0/1     Completed   0          3h14m
sas-crunchy-data-postgres-stanza-create-jt54s                     0/1     Completed   0          4h11m
sas-launcher-prepull-20200609-01-t2fhl                            0/1     Completed   0          4h22m
sas-reference-data-deploy-job-20200522-97crl                      0/1     Completed   0          4h22m
````

And finally you can use `-t All` to get a list of all pods (=`kubectl -n <namespace> get pods `)
```shell
./GetPodStatus.sh -n viya401 -t All
NAME                                                              READY   STATUS      RESTARTS   AGE
backrest-backup-sas-crunchy-data-postgres-6pc8x                   0/1     Completed   0          3h16m
sas-analytics-events-7d6f45844c-8rpv8                             1/1     Running     0          3h35m
sas-analytics-services-2-79f96cd47c-qv6jk                         1/1     Running     0          4h24m
...
sas-web-data-access-5b6b4997f7-hw686                              1/1     Running     3          4h23m
sas-workflow-64cbf6786-8h5xv                                      1/1     Running     4          4h23m
sas-workflow-definition-history-5b9f98f94f-x47qh                  1/1     Running     0          4h23m
sas-workflow-manager-app-586989bd7-67zbs                          1/1     Running     0          3h41m
```


### Examples

If you add a `watch`command around the `GetPodStatus.sh` you can "see" the progress of your SAS Viya4 deployment :  
(Make sure you add the `-c` option) 
```shell
watch -c -n 10 -d "./GetPodStatus.sh -n viya401"
Every 10.0s: ./GetPodStatus.sh -n viya401                                                                                              Wed Jul 22 14:18:10 2020

C...............................C....................................C......................C.................................
Others (O) ------------: 0
Pull Error (p) --------: 0
Terminating (T) -------: 0
Error (E) -------------: 0
Evicted (e) -----------: 0
Pending (P) -----------: 0
Initializing (I) ------: 0
CrashLoopBackOff (c) --: 0
Starting (s) ----------: 0
Completed (C) ---------: 4
Running (.) -----------: 122

Total -----------------: 126
```

And of course you can still use `grep` or other Linux commands on the output :
```shell
./GetPodStatus.sh -n viya401 -t All |grep -i crunchy
backrest-backup-sas-crunchy-data-postgres-6pc8x                   0/1     Completed   0          3h26m
sas-crunchy-data-postgres-6fd56bb4d8-m5rv2                        3/3     Running     0          4h28m
sas-crunchy-data-postgres-backrest-shared-repo-75b4c8d7df-bhhdc   1/1     Running     0          4h28m
sas-crunchy-data-postgres-flio-7c899466f-nnrzt                    3/3     Running     0          4h22m
sas-crunchy-data-postgres-operator-558bc55f6c-6z29n               4/4     Running     0          4h35m
sas-crunchy-data-postgres-sfue-579f5fdc8f-v5kl2                   3/3     Running     0          4h22m
sas-crunchy-data-postgres-stanza-create-jt54s                     0/1     Completed   0          4h23m
```

## getuserpods.sh

## mon-compute-pods.sh
Make sure you install the "resource-capacity" plugin in kubectl first : 
https://krew.sigs.k8s.io/plugins/

