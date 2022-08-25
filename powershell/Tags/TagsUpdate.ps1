
Write-Host ("#######################################################################################################") -ForegroundColor DarkGray
Write-Host ("############################## Adding tags to the VM and its associated items #########################") -ForegroundColor DarkGray
Write-Host ("#######################################################################################################") -ForegroundColor DarkGray
$InputFile= Read-Host -prompt "InputFile"
$VMList = Get-Content $InputFile
Write-Host("List of Servers:") -ForegroundColor Magenta
$VMList
$tags= @{Location="myLocation";Env="test";Application="SaiWebsite";Owner="Sai Kumar <Sai@gmail.com>"}
#Defining a Array of Vms 
#$VMList=@("AzureSite-VM","MyDockerVM","Onrem-VM")
$action="Merge"
#=============================Loop Section=================================================================#
foreach($VM in $VMList){
#Getting VM resource ID
Write-Host("### {0}  ###" -f $VM) -ForegroundColor yellow
$a=(get-azvm -name $VM).Id
#Adding tag to the VM
Update-AzTag -ResourceId $a -Tag $tags -Operation $action | Out-Null
if($?){
Write-Host ("### Tags {0}d on resource: '{1}' Successfully ### `n" -f $action, $VM) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on resource: '{1}' failed ### `n" -f $action, $VM) -ForegroundColor DarkRed
}

#Getting VM Nic resource ID adding tags
$vm_nic=get-azvm -name $VM
Update-AzTag -ResourceId ((get-azvm -name $VM).NetworkProfile).NetworkInterfaces.Id -Tag $tags -Operation $action | Out-Null

if($?){
Write-Host ("### Tags {0}d on {1} NetworkInterfaceCard Successfully ### `n" -f $action, $vm) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on {1} NetworkInterfaceCard failed ### `n" -f $action, $r.Name) -ForegroundColor DarkRed
}

#Getting storage profile details--------------------------------------------------------
$Disks=((get-azvm -name $VM).StorageProfile) | Select-Object -Property OsDisk,DataDisks
#Getting VM Os-Disk resource ID adding tags
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.OsDisk.Name).Id -Tag $tags -Operation $action | Out-Null
if($?){
Write-Host ("### Tags {0}d on {1} Os-Disk Successfully ### `n" -f $action, $vm) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on {1} Os-Disk failed ### `n" -f $action, $r.Name) -ForegroundColor DarkRed
}
#Getting VM Os-Disk resource ID adding tags
if($Disks.DataDisks){

$b=$Disks.DataDisks
if($b.Count -ge 1){
for($i=0;$i -lt $b.Count;$i=$i+1){
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.DataDisks[$i].Name).Id -Tag $tags -Operation $action | Out-Null
if($?){
Write-Host ("### Tags {0}d on resource: '{1}' Successfully ### `n" -f $action, (Get-Azdisk -name $Disks.DataDisks[$i].Name).Name) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on resource: '{1}' failed ### `n" -f $action, (Get-Azdisk -name $Disks.DataDisks[$i].Name).Name) -ForegroundColor DarkRed
}
}
}
else{
Update-AzTag -ResourceId (Get-Azdisk -name $Disks.DataDisks.Name).Id -Tag $tags -Operation $action | Out-Null
if($?){
Write-Host ("### Tags {0}d on resource: '{1}' Successfully ### `n" -f $action, (Get-Azdisk -name $Disks.DataDisks.Name).Name) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on resource: '{1}' failed ### `n" -f $action, (Get-Azdisk -name $Disks.DataDisks.Name).Name) -ForegroundColor DarkRed
}
#-------------------------------------------------------#end of the foreach section---------------------------------
}
}
}
