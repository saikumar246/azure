Param
        (
       
		[Parameter(Mandatory=$true)]  [String]$ResourceGroup,
		[Parameter(Mandatory=$true)]  [String]$nsgname
		)
		

$excel=New-Object -ComObject Excel.Application
#opening a excel sheet
$Workbook=$excel.workbooks.open("C:\Users\hdivvela\Downloads\Book2.xlsx")#update the input file path
#$excel.Visible=$true
#Accessing a particular sheet
$workSheet = $Workbook.Sheets.Item(1)
# Get the number of filled in rows in the XLSX worksheet
$rowcount=$WorkSheet.UsedRange.Rows.Count
#$rowcount
$j=0

Write-Host ("### Adding rules to the {0} ...... ###" -f ,$nsgname) -ForegroundColor Green
For($i=2;$i -lt $rowcount+1;$i=$i+1){
#Reading data from the excel
Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray
$rulename=$workSheet.Cells.Item($i,1).text
Write-Host("Rule Name = {0}" -f ,$rulename)
$Description=$workSheet.Cells.Item($i,2).text
Write-Host("Description = {0}" -f ,$Description)
$Access=$workSheet.Cells.Item($i,3).text
Write-Host("Access = {0}" -f ,$Access)
$Protocol=$workSheet.Cells.Item($i,4).text
Write-Host("Protocol = {0}" -f ,$Protocol)
$Direction=$workSheet.Cells.Item($i,5).text
Write-Host("Direction = {0}" -f ,$Direction)
$Priority=$workSheet.Cells.Item($i,6).text
Write-Host("Priority = {0}" -f ,$Priority)
$SourceAddressPrefix=$workSheet.Cells.Item($i,7).text
$SourceAddressPrefix_array=$SourceAddressPrefix.Split(',')
Write-Host("SourceAddressPrefix = {0}" -f ,$SourceAddressPrefix)
$SourceASG=$workSheet.Cells.Item($i,8).text
$SourceASG_array=$SourceASG.Split(',')
Write-Host("SourceASG = {0}" -f ,$SourceASG)
$SourcePortRange=$workSheet.Cells.Item($i,9).text
Write-Host("SourcePortRange = {0}" -f ,$SourcePortRange)
$DestinationAddressPrefix=$workSheet.Cells.Item($i,10).text
$DestinationAddressPrefix_array=$DestinationAddressPrefix.Split(',')
Write-Host("DestinationAddressPrefix = {0}" -f ,$DestinationAddressPrefix)
$DestinationASG=$workSheet.Cells.Item($i,11).text
Write-Host("DestinationASG = {0}" -f ,$DestinationASG)
$DestinationPortRange=$workSheet.Cells.Item($i,12).text
$DestinationPortRange_array=$DestinationPortRange.Split(',')
Write-Host("DestinationPortRange = {0}" -f ,$DestinationPortRange)
Write-Host("---------------------------------------------------------------------------------------------------------") -ForegroundColor DarkGray
if(($SourceASG) -and ($DestinationASG)){

$srcAsg = Get-AzApplicationSecurityGroup -Name $SourceASG
$destASG=Get-AzApplicationSecurityGroup -Name $DestinationASG
Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroup |
Add-AzNetworkSecurityRuleConfig -Name $rulename -Description $Description -Access `
    $Access -Protocol $Protocol -Direction $Direction -Priority $Priority -SourceApplicationSecurityGroup `
    $srcASG -SourcePortRange $SourcePortRange -DestinationApplicationSecurityGroup $destASG -DestinationPortRange $DestinationPortRange_array |
    Set-AzNetworkSecurityGroup | Out-Null
}

elseif(($SourceASG) -and (!$DestinationASG)){
$srcAsg = Get-AzApplicationSecurityGroup -Name $SourceASG

Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroup |
Add-AzNetworkSecurityRuleConfig -Name $rulename -Description $Description -Access `
    $Access -Protocol $Protocol -Direction $Direction -Priority $Priority -SourceApplicationSecurityGroup `
    $srcAsg -SourcePortRange $SourcePortRange -DestinationAddressPrefix $DestinationAddressPrefix_array -DestinationPortRange $DestinationPortRange_array |
    Set-AzNetworkSecurityGroup | Out-Null

}
elseif((!$SourceASG) -and ($DestinationASG)){

$destASG = Get-AzApplicationSecurityGroup -Name $DestinationASG

Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroup | 
Add-AzNetworkSecurityRuleConfig -Name $rulename -Description $Description -Access `
    $Access -Protocol $Protocol -Direction $Direction -Priority $Priority -SourceAddressPrefix $SourceAddressPrefix_array `
    -SourcePortRange $SourcePortRange -DestinationApplicationSecurityGroup $destASG -DestinationPortRange $DestinationPortRange_array |
    Set-AzNetworkSecurityGroup | Out-Null

}
else{
Get-AzNetworkSecurityGroup -Name $nsgname -ResourceGroupName $ResourceGroup | 
Add-AzNetworkSecurityRuleConfig -Name $rulename -Description $Description -Access `
    $Access -Protocol $Protocol -Direction $Direction -Priority $Priority -SourceAddressPrefix $SourceAddressPrefix_array `
    -SourcePortRange $SourcePortRange -DestinationAddressPrefix $DestinationAddressPrefix_array -DestinationPortRange $DestinationPortRange_array |
    Set-AzNetworkSecurityGroup | Out-Null
}
if ($?) { $j=$j+1}
}

Write-Host ("### {0} rules added to the {1} Successfully ###" -f $j, $nsgname) -ForegroundColor Green




