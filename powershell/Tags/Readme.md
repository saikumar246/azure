<==================================================================================>

This script is for tagging(Same tags) for 'N' number of VMs at the same time.

Tags and VMS should give in the input text file.
For the Format to give details in the input file, you can see the sample input file.
Script Paramaters:- $InputFile, $ResouceGroup 

===================
SampleInputFile.txt 
===================
@{Location="myLocation";Env="prod";Application="SaiWebsite";Owner="Sai Kumar <Sai@gmail.com>";Support="CloudOps pod1";maintenance="23:00";RoomMate="Pavan Bros"}
AzureSite-VM
MyDockerVM
Onrem-VM
<==================================================================================>
