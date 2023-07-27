targetScope = 'resourceGroup'

/* -------------------------------------------------------------------------- */
/*                                 PARAMETERS                                 */
/* -------------------------------------------------------------------------- */

@description('Name of the container app.')
param name string

@description('Location in which the resources will be deployed. Default value is the resource group location.')
param location string = resourceGroup().location

@description('Tags that will be added to all the resources. For Azure Developer CLI, "azd-env-name" should be added to the tags.')
param tags object = {}

@description('Name of the service. This name is used to add "azd-service-name" tag to the tags for the container app. Default value is "frontend". If you change this value, make sure to change the name of the service in "azure.yaml" file as well.')
param serviceName string = 'frontend'

@description('Name of the identity that will be created and used by the container app to pull image from the container registry.')
param identityName string

@description('URI of the AI Shopping Cart service that is used to managed the cart items.')
param aiShoppingCartServiceUri string

@description('Name of the existing Application Insights instance that will be used by the container app.')
param applicationInsightsName string

@description('Name of the existing container apps environment.')
param containerAppsEnvironmentName string

@description('Name of the existing container registry that will be used by the container app.')
param containerRegistryName string

@description('Flag that indicates whether the container app already exists or not. This is used in container app upsert to set the image name to the value of the existing container apps image name.')
param exists bool

/* -------------------------------------------------------------------------- */
/*                                  RESOURCES                                 */
/* -------------------------------------------------------------------------- */

resource frontendIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: applicationInsightsName
}

module app '../core/host/container-app-upsert.bicep' = {
  name: '${serviceName}-container-app'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    identityType: 'UserAssigned'
    identityName: identityName
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    env: [
      {
        name: 'REACT_APP_APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
      {
        name: 'REACT_APP_API_URL'
        value: aiShoppingCartServiceUri
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsights.properties.ConnectionString
      }
    ]
    targetPort: 80
  }
}

/* -------------------------------------------------------------------------- */
/*                                   OUTPUTS                                  */
/* -------------------------------------------------------------------------- */

@description('ID of the service principal that is used by the container app to pull image from the container registry.')
output SERVICE_FRONTEND_IDENTITY_PRINCIPAL_ID string = frontendIdentity.properties.principalId

@description('Name of the container app.')
output SERVICE_FRONTEND_NAME string = app.outputs.name

@description('URI of the container app.')
output SERVICE_FRONTEND_URI string = app.outputs.uri

@description('Name of the container apps image.')
output SERVICE_FRONTEND_IMAGE_NAME string = app.outputs.imageName
