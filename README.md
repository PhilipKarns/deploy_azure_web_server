# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction

This project is for writing a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure. The Packer template allows us to create an image that will allow us to create multiple virtual machines at the 
same time through Terraform, which will contain all of our infrastructure to be deployed, including: storage, security, and networking configurations.   

## Getting Started

To begin using this project, start with these steps:
1. Clone this repository
2. Create your infrastructure as code
3. Create your tagging policy in Azure
4. Create your resource group in Azure

## Dependencies

1. Create and Azure Account
2. Install the Azure CLI
3. Install Packer
4. Install Terraform

## Instructions
After the dependencies have been create or installed, it's time to create and deploy the Packer and Terraform templates

### Deploy the Packer Image Template

Packer deploys virtual machine images which can be used to create multiple virtual machines. 

#### Get your unique variables
The packer image is created using the server-template.json file. The values for the client_id, client_secret, and tenent_id variables will be unique to you, and you can get them by following these steps:

* Log into your Azure account
* in the Azure CLI run command **az ad sp create-for-rbac**

The output should look something like this:

```
{
    "client_id": "f5b6a5cf-fbdf-4a9f-b3b8-3c2cd00225a4",
    "client_secret": "0e760437-bf34-4aad-9f8d-870be799c55d",
    "tenant_id": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}
```

For the subscription_id variable, you'll need your Azure subscription code. To get that, in the Azure CLI run **az account list** and copy the value from the "id" field. 

#### Deploy the Packer Image

To deploy the image, in the Azure CLI run the command **packer build server.json**

## Deploy Infrastructure With Terraform

Terraform is used to quickly deploy all of our infrastructure, which is listed in the main.tf file, and also utilizes variables in the vars.tf file. The packer image is referenced in the variables section and is used in the 
template to create our virtual machines. 

### Deploy the Infrastructure

To deploy, perform the following steps:

* In our Packer image we created a resource group, and we need to import that into Terraform before deploying, so Terraform will used that resource group, instead of trying to create another resource group with the same name, which
isn't allowed. To do this we need to run the command **terraform import azurerm_resource_group.main /subscriptions/{subsriptionId}/resourceGroups/{resourceGroupName}**. 
* In the Azure CLI run the command **terraform plan -out solution.plan** to review what infrastructure will be deployed and saved to disk.
* In the Azure CLI run the command **terraform apply** to deploy the infrastructure. 
* After the infrastructure is deployed, run command **terraform show** in the Azure CLI to review the resources.
* Once the infrastructure has successfully been deployed, we want to then destroy the infrastructure. In the Azure CLI run the command **terraform destroy**. 
* Run **terraform show** again to confirm all resources have been destroyed.






Output
Your words here