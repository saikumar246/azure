#-----------------------------------------------Script Begin-------------------------------------------------
#defining tags
$tags= @{Location="myLocation";Env="test";Application="SaiWebsite";Owner="Sai Kumar <Sai@gmail.com>"}
#Defining a Array of Vms 
$VMList=@("AzureSite-VM","MyDockerVM","Onrem-VM")
$action="Replace"
foreach($VM in $VMList){
#Getting VM resource ID
$a=(get-azvm -name $VM).Id
#Adding tag to the VM
Update-AzTag -ResourceId $a -Tag $tags -Operation $action
#Getting VM Nic resource ID adding tags
Update-AzTag -ResourceId ((get-azvm -name $VM).NetworkProfile).NetworkInterfaces.Id -Tag $tags -Operation $action
#Getting storage profile details--------------------------------------------------------
$Disks=((get-azvm -name $VM).StorageProfile) | Select-Object -Property OsDisk,DataDisks
#Getting VM Os-Disk resource ID adding tags
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.OsDisk.Name).Id -Tag $tags -Operation $action
#Getting VM Os-Disk resource ID adding tags
if($Disks.DataDisks){

$b=$Disks.DataDisks
if($b.Count -ge 1){
for($i=0;$i -lt $b.Count;$i=$i+1){
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.DataDisks[$i].Name).Id -Tag $tags -Operation $action
}
}
else{
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.DataDisks.Name).Id -Tag $tags -Operation $action
#-------------------------------------------------------#end of the foreach section---------------------------------
}
}
}
