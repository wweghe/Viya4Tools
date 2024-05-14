RG=hardy-rg
AKS=hardy-aks
NS=viya4

echo "Stopping SAS Viya"
TS=`date +%s`
kubectl create job sas-stop-all-$TS --from cronjobs/sas-stop-all -n $NS
kubectl -n $NS  wait --for=condition=complete  --timeout=1800s job/sas-stop-all-$TS

echo "Stopping AKS cluster"

az aks stop -g $RG -n $AKS

# NODE_RESOURCE_GROUP=$(az aks show --resource-group $RG --name $AKS --query nodeResourceGroup -o tsv)
# VMSSsystem=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'system')].[name]" -o tsv)
# VMSScas=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'cas')].[name]" -o tsv)
# VMSScompute=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'compute')].[name]" -o tsv)
# VMSSgeneric=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'generic')].[name]" -o tsv)
# echo $VMSScas
# az vmss deallocate --name $VMSScas     --resource-group $NODE_RESOURCE_GROUP
# echo $VMSScompute
# az vmss deallocate --name $VMSScompute --resource-group $NODE_RESOURCE_GROUP
# echo $VMSSgeneric
# az vmss deallocate --name $VMSSgeneric --resource-group $NODE_RESOURCE_GROUP
# echo $VMSSsystem
# az vmss deallocate --name $VMSSsystem  --resource-group $NODE_RESOURCE_GROUP

echo "Stopping VMs in " $RG
az vm deallocate  --ids $(az vm list -g $RG --query "[].id" -o tsv)
