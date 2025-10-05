# azure-terraform-flowise

This repository cotains Terraform code to deploy flowise to Azure in a secured environment.

## What is deployed?

The deployment includes the folowing resources:
- VNet and Subnets
- (Optinal) Bastion Host for access if needed
- PostgreSQL flexible server as a database for Flowise
- Storage Account with Azure Files as a mount for uploaded files
- Azure Container Registry to host the Flowise image
- Flowise deployment as a WebApp
- (Optinal) VM for accessing different parts of the infrastructure as everything uses privatelink endpoints for a secured, enterprise grade deployment.

## What problem does this repo solve
The official Flowise documentation contains a section on how to deploy to Azure. The code in this Repo is based on the "Flowise as Azure App Service with Postgres: Using Terraform" section of the documentation. Sadly the code provided on the flowise site does not work and does not include all needed parts. This repositoy tries to fix the missing parts and provide a way to deploy flowise to Azure.

## Installation Steps

### Prerequisits
You will need:
1. A Azure account. Be aware that the deployment of the resources will incure costs.
2. he Azure CLI. You should have the Azure CLI installed.
3. Terraform. Also terraform needs to be installed and in your PATH for the following instructions to work.
