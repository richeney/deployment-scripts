# deployment-scripts

## Introduction

Small repo to demonstrate the new deployment script functionality in ARM.

Reference: <https://docs.microsoft.com/azure/azure-resource-manager/templates/deployment-script-template?tabs=CLI>

The reference documentation covers Bash v PowerShell and inline v uri.

## Instructions

Run the deployment_script.sh in WSL2 or the Cloud Shell to create

  1. resource group
  1. user assigned managed identity|
  1. RBAC assignment
  1. example parameters file
  1. deployment

The script shows the az commands as it runs.

## Gotchas

Using inline scripts is painful. (Worked for me once I'd used the JSON Tools extension which moved the multi-lines to one long string with \n.)

The example uses scriptUris.

## Upcoming changes

This template generates a temporary container and storage account.

I think it will run faster with dedicated resources and references to them.
