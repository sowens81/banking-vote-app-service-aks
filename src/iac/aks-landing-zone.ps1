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
    # Resource naming
    $resourceGroupName = "rg-$DepartmentCode-$ApplicationName-$Environment-$Region-01"
    $aksClusterName = "aks-$DepartmentCode-$ApplicationName-$Environment-$Region-01"
    $acrName = "acr$DepartmentCode$ApplicationName$Environment$Region" + "01"

    Write-Output "Starting resource creation..."
    
    if ((az group exists --name) -eq $false) {
        Write-Output "Creating Resource Group: $resourceGroupName"
        az group create --name $resourceGroupName --location $Regio
    } else {
        Write-Output "Resource Group already exists: $resourceGroupName"
    }

    
    try {
        $acr = az acr show --name $acrName --resource-group $resourceGroupName--query "name" --output tsv
        if ($acr) {
            Write-Output "Acr already exists: $acrName"
        }
    } catch {
        Write-Output "Creating Acr: $acrName"
        az acr create --name $acrName --resource-group $resourceGroupName --sku Basic
    }

    try {
        $aks = az aks show --name $aksName --resource-group $resourceGroupName --query "name" --output tsv
        if ($aks) {
            Write-Output "AKS already exists: $aksClusterName"
        }
    } catch {
        Write-Output "Creating AKS: $aksClusterName"
        az aks create --name $aksClusterName --resource-group $resourceGroupName --node-count 1 --node-vm-size Standard_D2as_v5 --enable-addons monitoring --network-plugin kubenet --network-policy calico --generate-ssh-keys
    }

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