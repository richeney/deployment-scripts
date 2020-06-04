#!/bin/bash

read -e -i westeurope         -p "Azure region               : " location
read -e -i deployment_scripts -p "resource group name        : " resource_group_name
read -e -i scripts_msi        -p "user managed identity name : " msi_name

location=${location:-westeurope}
resource_group_name=${resource_group_name:-deployment_scripts}
msi_name=${msi_name:-scripts_msi}

set -x

az group create --name $resource_group_name --location $location --output jsonc
# scope_id=$(az group show --name $resource_group_name --query id --output tsv)

az identity create --resource-group $resource_group_name --name $msi_name --output jsonc

msi_principal_id=$(az identity show --resource-group $resource_group_name --name $msi_name --query principalId --output tsv)
msi_resource_id=$(az identity show --resource-group $resource_group_name --name $msi_name --query id --output tsv)

az role assignment create --role Contributor --assignee $msi_principal_id --resource-group $resource_group_name

cat > example_parameters.json <<EOF
{
  "\$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "managed_identity": {
      "value": "$msi_resource_id"
    },
    "name": {
      "value": "'$(whoami)'"
    }
  }
}
EOF

if which jq 1>/dev/null 2>&1
then jq . < example_parameters.json
else cat example_parameters.json
fi

az deployment group validate --name deployment_scripts --resource-group $resource_group_name --template-file example.json --parameters "@example_parameters.json" --verbose

set +x
exit 0
