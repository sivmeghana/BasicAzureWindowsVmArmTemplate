<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER templateFilePath
    Optional, path to the template file. 

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. 
#>

param(
 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $templateFilePath = "template.json",

 [string]
 $parametersFilePath = "parameters.json"
)

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# ensure you are signed in and using the proper subscription
# Get-AzSubscription

# enter the admin password
$adminPass = Read-Host -AsSecureString -Prompt 'Admin password'

# load the parameters so we can use them in the script
$params = ConvertFrom-Json -InputObject (Gc $parametersFilePath -Raw)

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Creating resource group '$resourceGroupName' in location $($params.parameters.location.value)";
    New-AzResourceGroup -Name $resourceGroupName -Location $params.parameters.location.value -Verbose 
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}

# Test
Write-Host "Testing deployment...";
$testResult = Test-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -adminPassword $adminPass -ErrorAction Stop;
if ($testResult.Count -gt 0)
{
	write-host ($testResult | ConvertTo-Json -Depth 5 | Out-String);
	write-output "Errors in template - Aborting";
	exit;
}

# Start the deployment
Write-Host "Starting deployment..." $(Get-Date);
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -adminPassword $adminPass -Verbose;
