RG=hardy-rg
AKS=hardy-aks
NS=viya4

echo "Starting VMs in " $RG
az vm start --ids $(az vm list -g $RG --query "[].id" -o tsv)


echo "Starting AKS Cluster"

az aks start -g $RG -n $AKS

# NODE_RESOURCE_GROUP=$(az aks show --resource-group $RG --name $AKS --query nodeResourceGroup -o tsv)
# VMSSsystem=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'system')].[name]" -o tsv)
# VMSScas=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'cas')].[name]" -o tsv)
# VMSScompute=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'compute')].[name]" -o tsv)
# VMSSgeneric=$(az vmss list --resource-group $NODE_RESOURCE_GROUP --query "[?contains(name,'generic')].[name]" -o tsv)
# echo $VMSSsystem
# az vmss restart --name $VMSSsystem  --resource-group $NODE_RESOURCE_GROUP
# echo $VMSSgeneric
# az vmss restart --name $VMSSgeneric --resource-group $NODE_RESOURCE_GROUP
# echo $VMSScompute
# az vmss restart --name $VMSScompute --resource-group $NODE_RESOURCE_GROUP
# echo $VMSScas
# az vmss restart --name $VMSScas     --resource-group $NODE_RESOURCE_GROUP

echo "Starting SAS Viya"

kubectl create job sas-start-all-`date +%s` --from cronjobs/sas-start-all -n $NS
