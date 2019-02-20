# Basic Azure Windows VM ARM Template
This is a basic Azure ARM Template and associated PowerShell deployment script to create a Windows VM using Managed Disks. This is similar to [BasicAzureLinuxVmArmTemplate](https://github.com/ssemyan/BasicAzureLinuxVmArmTemplate) but with two differences: 

1. It uses [Managed Disks](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/managed-disks-overview) for VM disks instead of a Storage Account.
1. An admin password is used instead of a key. This is entered when the _deploy.ps1_ script is run. **Note: best practice would be to store this setting in a [KeyVault](https://azure.microsoft.com/en-us/services/key-vault/) and retrieve it from there as described here: https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-manager-keyvault-parameter**

This script will create the resource group in the selected location if it does not already exist. 

To use these files to create a Windows VM (Datacenter 2016) in a new or existing resource group, use the following command in a powershell prompt:

    .\deploy.ps1 -subscriptionId [SubscriptionId] -resourceGroupName [ResourceGroupName]
     
To run from a command prompt:

    powershell -f deploy.ps1 -subscriptionId [SubscriptionId] -resourceGroupName [ResourceGroupName]

Enter the admin password when prompted:

    PS C:\source\BasicAzureWindowVmArmTemplate> .\deploy.ps1 -resourceGroupName mygroup
    Admin password: ****************
