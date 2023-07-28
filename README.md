# AI Shopping Cart - App Template for Java, Azure OpenAI and Azure Spring Apps

[![Open in GitHub Codespaces](https://img.shields.io/badge/Github_Codespaces-Open-black?style=for-the-badge&logo=github
)](https://codespaces.new/Azure-Samples/app-templates-java-openai-springapps)
[![Open in Remote - Dev Containers](https://img.shields.io/badge/Dev_Containers-Open-blue?style=for-the-badge&logo=visualstudiocode
)](https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/Azure-Samples/app-templates-java-openai-springapps)

AI Shopping Cart is a sample application that supercharges your shopping experience with the power of AI. It leverages Azure OpenAI and Azure Spring Apps to build a recommendation engine that is not only scalable, resilient, and secure, but also personalized to your needs. Taking advantage of Azure OpenAI, the application performs nutrition analysis on the items in your cart and generates the top 3 recipes using those ingredients. With Azure Developer CLI (azd), you’re just a few commands away from having this fully functional sample application up and running in Azure. Let's get started!

## Pre-requisites

* [Install the Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
* An Azure account with an active subscription. [Create one for free](https://azure.microsoft.com/free).
* [OpenJDK 17](https://learn.microsoft.com/en-us/java/openjdk/install)
* [Node.js 20.5.0+](https://nodejs.org/en/download/)
* [Docker](https://docs.docker.com/get-docker/)
* [Azure OpenAI with `gpt-4`](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview#how-do-i-get-access-to-azure-openai)
* Review the architecture diagram and the resources you'll deploy

## Quickstart

To learn how to get started with any template, follow [this quickstart](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/get-started?tabs=localinstall&pivots=programming-language-java). For this template `Azure-Samples/app-templates-java-openai-springapps`, you need to execute a few additional steps as described below.

This quickstart will show you how to authenticate on Azure, enable Spring Apps [alpha feature](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/feature-versioning#alpha-features) for azd, initialize using a template, set the [environment variables](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/manage-environment-variables) for Azure OpenAI, provision the infrastructure, and deploy the code to Azure:

```bash
# Log in to azd if you haven't already
azd auth login

# Enable Azure Spring Apps alpha feature for azd
azd config set alpha.springapps on

# First-time project setup. Initialize a project in the current directory using this template
azd init --template Azure-Samples/app-templates-java-openai-springapps

# Set the environment variables for Azure OpenAI
azd env set azureOpenAiApiKey=<replace-with-Azure-OpenAi-API-key> 
azd env set azureOpenAiEndpoint=<replace-with-Azure-OpenAi-endpoint>
azd env set azureOpenAiDeploymentId=<replace-with-Azure-OpenAi-deployment-id>

# Provision and deploy to Azure
azd up
```

> Note: Replace the placeholders with the values from your Azure OpenAI resource.

At the end of the deployment, you will see the URL of the front-end. Open the URL in a browser to see the application in action.

