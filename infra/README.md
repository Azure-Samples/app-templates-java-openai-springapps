# Infrastructure for AI Shopping Cart Sample App

This folder contains the infrastructure for the AI Shopping Cart sample apps. The infrastructure is supposed to be deployed using [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview) (azd). You can check the [AI Shopping Cart README](../README.md) for more information about the sample apps and to deploy it using `azd`.

## Deploy with Azure Developer CLI

To deploy only the infrastructure, you can use the following command in the root folder of this repository:

```bash
azd provision
```

Be sure to set all the parameters as described in the [AI Shopping Cart README](../README.md).

## Deploy with Azure CLI

It can also be deployed manually using [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) (az). The following instructions assume you have already installed Azure CLI. Follow these steps to deploy the infrastructure:

1. Login to Azure CLI using the following command:

    ```bash
    az login
    ```

1. Set the subscription you want to use:

    ```bash
    az account set --subscription <subscription-id>
    ```

1. Set the required parameters in `main.parameters.json` file

1. Deploy the template:

    ```bash
    az deployment sub --template-file main.bicep --location <location> --name <deployment-name> --parameters ./main.parameters.json
    ```