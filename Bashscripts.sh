#!/bin/bash
#connect and set Subscription Context in Azure
az login
az account set --subscription "LTTS_DevOps"


#set variables for storage account and key vault that support the terraform implementation
RESOURCE_GROUP_NAME=danda-infra
STORAGE_ACCOUNT_NAME=dandatstate
CONTAINER_NAME=tstate
STATE_FILE=terraform.state

# Create resource group
az group create --name danda-infra --location uksouth

# Create storage account
az storage account create --resource-group danda-infra --name dandatstate --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group danda-infra --account-name dandatstate --query '[0].value' -o tsv)

# Create blob container
az storage container create --name tstate --account-name dandatstate --account-key $ACCOUNT_KEY

#Show the details for the purpose of this code
echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"


#create Keyvault and example of storing a key
az keyvault create --name "dandakv" --resource-group "danda-infra" --location uksouth
az Keyvault create set --vault-name "dandakv" --name "tstateaccess" --value {$ACCOUNT_KEY}
az keyvault secret show --vault-name "dandakv" --name "tstateaccess"