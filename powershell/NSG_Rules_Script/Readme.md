Steps to follow to run the script:-
1.	Update the NSG rules in the attached excel sheet format.
2.	The Input File path has to update in the script.
3.	Connect to Azure Portal before running the script.
4.	Provide the RG and NSG name while running the script.

The following possible NSG rules will work in this script,
1.	IP addresses to IP addresses.
2.	IP addresses to ASG(single).
3.	ASG(single) to IP addresses.
4.	Service tag to IP addresses.
5.	IP addresses to Service tag.
6.	Service tag to ASG(single).
7.	ASG(single) to Service tag.

Note:- This Script Can’t Support the Multiple ASG’s in the single rule.
