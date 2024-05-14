# Demo Assessment - AKS Voting Service Deployment

This is a demo assessment for deploying a Voting Service application to Azure Kubernetes Service (AKS). The Voting Service application is a simple web application that allows users to vote for their favorite option (either "Cats" or "Dogs"). The application consists of two components: a frontend web application and a backend API.

The frontend web application is a simple HTML page that displays the two options ("Cats" and "Dogs") and allows users to vote for their favorite option. The backend API is a simple REST API that stores the votes in a Redis database.

## Prerequisites

1. Create a DevOps Project in Azure DevOps called Banking-AKS-Voting-Demo.
2. Create a Azure DevOps Repo called voteapp-service.
3. Add the repo main origin to this repo and push up the code.
4. Create an ADO Pipeline called cicd-voteapp-iac and attach to the yaml pipeline /.pipelines/iac-ci-cd-pipeline.yml.
5. Create an ADO Pipeline called cicd-voteapp-service and attach to the yaml pipeline /.pipelines/azure-pipeline.yml.
6. Create an environment in Azure DevOps called Prod, you can also define Approval Gates if you want for product releases.
7. Create a Azure DevOps Service Connection to your Azure Resource Manager called voteap-azure-prod-service-principle-connection.
8. Start the cicd-voteapp-iac to deploy the required azure resources.
9. Create a Azure DevOps Service Connection to your Docker ACR service called voteap-acr-prod-service-principle-connection.
10. Create a Azure DevOps Service Connection to your AKS service called voteap-aks-prod-service-principle-connection.
11. Start the cicd-voteapp-service to deploy the required azure resources.