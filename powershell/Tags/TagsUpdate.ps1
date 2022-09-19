
#=============================Parameter Section============================================================#

Write-Host ("#######################################################################################################") -ForegroundColor DarkGray
Write-Host ("############################## Adding tags to the VM and its associated items #########################") -ForegroundColor DarkGray
Write-Host ("#######################################################################################################") -ForegroundColor DarkGray
$InputFile= Read-Host -prompt "InputFile"
$RG=Read-Host -prompt "ResourceGroupName"
$VMList = Get-Content $InputFile
Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray
Write-Host("List of Servers:") -ForegroundColor Magenta
$VMList[1..$VMList.Count]
#$tags= @{Location="myLocation";Env="prod";Application="SaiWebsite";Owner="Sai Kumar <Sai@gmail.com>";Support="CloudOps pod1";maintenance="23:00"}
$tags=(Invoke-Expression $VMList[0])
#Defining a Array of Vms 
#$VMList=@("AzureSite-VM","MyDockerVM","Onrem-VM")
#The 'merge' option allows adding tags with new names and updating the values of tags with existing names.
#The 'replace' option replaces the entire set of existing tags with a new set.
$action="Merge"

Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray
Write-Host("####Check the Tags before adding to the resources ####") -ForegroundColor Magenta
$tags
Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray

$check=Read-Host -prompt("*********Continue? (yes/No)")
if($check -eq "No"){ 
Write-Host("Terminating the script and exit.....") -ForegroundColor Green
Start-Sleep -Seconds 2
exit(0)}

Update-AzTag -ResourceId (Get-AzResourceGroup -name $RG).ResourceId -Tag $tags -Operation $action | Out-Null
if($?){
Write-Host ("### Tags {0}d on resource Group: '{1}' Successfully ### `n" -f $action, $RG) -ForegroundColor Green
} else {
Write-Host ("### Tags {0} on resource Group: '{1}' failed ### `n" -f $action, $RG) -ForegroundColor DarkRed
}

#=============================Loop Section=================================================================#
for($j=1;$j -lt $VMList.Count;$j=$j+1){
$VM=$VMList[$j]
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
}
}
}
Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray
if($?){
Write-Host("Script executed Successfully, exiting the script....") -ForegroundColor Green
Start-Sleep -Seconds 2
}
else{Write-Host("Scrit executed with errors, exiting the script") -ForegroundColor red}
#-------------------------------------------------------#end of the foreach section---------------------------------




