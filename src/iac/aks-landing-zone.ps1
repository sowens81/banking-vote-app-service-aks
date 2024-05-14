param(
    [Parameter(Mandatory = $true)]
    [string]$Environment,
    [Parameter(Mandatory = $true)]
    [string]$Region,
    [Parameter(Mandatory = $true)]
    [string]$ApplicationName,
    [Parameter(Mandatory = $true)]
    [string]$DepartmentCode,
    [Parameter(Mandatory = $true)]
    [ValidateSet("Create", "Delete")]
    [string]$Action
)

function CreateResources {
    Write-Output "Starting resource creation..."

    $resourceGroupName = "rg-$DepartmentCode-$ApplicationName-$Environment-$Region-01"
    $aksClusterName = "aks-$DepartmentCode-$ApplicationName-$Environment-$Region-01"
    $acrName = "acr$DepartmentCode$ApplicationName$Environment$Region" + "01"

    az group create --name $resourceGroupName --location $Region
    az acr create --name $acrName --resource-group $resourceGroupName --sku Basic
    az aks create --name $aksClusterName --resource-group $resourceGroupName --node-count 1 --node-vm-size Standard_D2as_v5 --enable-addons monitoring --network-plugin kubenet --network-policy calico --generate-ssh-keys

    Write-Output "Resource Group Name: $resourceGroupName"
    Write-Output "AKS Cluster Name: $aksClusterName"
    Write-Output "ACR Name: $acrName"

    Write-Output "Resource creation completed."
}

function DeleteResources {
    $resourceGroupName = "rg-$DepartmentCode-$ApplicationName-$Environment-$Region-01"

    Write-Output "Starting resource deletion..."
    # Delete Resource Group and all associated resources
    az group delete --name $resourceGroupName --yes --no-wait

    Write-Output "Resource deletion initiated."
}

if ($Action -eq "Create") {
    CreateResources
} elseif ($Action -eq "Delete") {
    DeleteResources
}