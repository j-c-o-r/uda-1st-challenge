# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
This project allows a user to setup a scalable web server with a configurable number of virtual machines

### Getting Started
you need to have terraform, packer and azure cli installed

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Create a subscription

### Instructions
1. create the resource group udacity-demo-rg
2. deploy the images with: packer build server.json
3. create a terraform plan with: terraform plan -out solution.plan
4. apply the terraform plan with: terraform apply solution.plan
 
### Output
a complete server setup with:
  - virtual network
  - load balancer
  - public ip
  - availability set
  - configurable number of vms and respective network interface cards


