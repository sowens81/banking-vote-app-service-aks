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

    # Create Resource Group
    Write-Output "Creating Resource Group..."
    try {
        $existingRG = az group show --name $resourceGroupName --query id -o tsv
        Write-Output "Resource Group '$resourceGroupName' already exists."
    }
    catch {
        Write-Output "Resource Group '$resourceGroupName' not found. Creating..."
        az group create --name $resourceGroupName --location $Region
    }

    # Create ACR
    Write-Output "Creating ACR..."
    try {
        $existingACR = az acr show --name $acrName --resource-group $resourceGroupName --query id -o tsv
        Write-Output "ACR '$acrName' already exists."
    }
    catch {
        Write-Output "ACR '$acrName' not found. Creating..."
        az acr create --name $acrName --resource-group $resourceGroupName --sku Basic
    }

    # Create AKS Cluster
    Write-Output "Creating AKS Cluster..."
    try {
        $existingAKS = az aks show --name $aksClusterName --resource-group $resourceGroupName --query id -o tsv
        Write-Output "AKS Cluster '$aksClusterName' already exists."
    }
    catch {
        Write-Output "AKS Cluster '$aksClusterName' not found. Creating..."
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
