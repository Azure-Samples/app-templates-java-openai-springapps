targetScope = 'subscription'

/* -------------------------------------------------------------------------- */
/*                                 PARAMETERS                                 */
/* -------------------------------------------------------------------------- */

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a name for all resources. Use only alphanumerics and hyphens. For resource that requires globally unique name, a token is generated based on this name and the ide of the subscription.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

/* ----------------------------- Resource Names ----------------------------- */

@maxLength(90)
@description('Name of the resource group to deploy. If not specified, a name will be generated.')
param resourceGroupName string = ''

@maxLength(60)
@description('Name of the container apps environment to deploy. If not specified, a name will be generated. The maximum length is 60 characters.')
param containerAppsEnvironmentName string = ''

@maxLength(50)
@description('Name of the container registry to deploy. If not specified, a name will be generated. The name is global and must be unique within Azure. The maximum length is 50 characters.')
param containerRegistryName string = ''

@maxLength(63)
@description('Name of the log analytics workspace to deploy. If not specified, a name will be generated. The maximum length is 63 characters.')
param logAnalyticsWorkspaceName string = ''

@maxLength(255)
@description('Name of the application insights to deploy. If not specified, a name will be generated. The maximum length is 255 characters.')
param applicationInsightsName string = ''

@maxLength(160)
@description('Name of the application insights dashboard to deploy. If not specified, a name will be generated. The maximum length is 160 characters.')
param applicationInsightsDashboardName string = ''

@maxLength(32)
@description('Name of the spring apps instance to deploy the AI shopping cart service. If not specified, a name will be generated. The maximum length is 32 characters. It contains only lowercase letters, numbers and hyphens.')
param springAppsInstanceName string = ''

@maxLength(63)
@description('Name of the PostgreSQL flexible server to deploy. If not specified, a name will be generated. The name is global and must be unique within Azure. The maximum length is 63 characters. It contains only lowercase letters, numbers and hyphens, and cannot start or end with a hyphen.')
param postgresFlexibleServerName string = ''

/* ------------------------------- PostgreSQL ------------------------------- */

@description('Name of the PostgreSQL admin user.')
param postgresAdminUsername string = 'shoppingcartadmin'

@secure()
@description('Password for the PostgreSQL admin user. If not specified, a password will be generated.')
param postgresAdminPassword string = newGuid()

/* -------------------------------- Front-end ------------------------------- */

@maxLength(32)
@description('Name of the frontend container app to deploy. If not specified, a name will be generated. The maximum length is 32 characters.')
param frontendContainerAppName string = ''

@description('Set if the frontend container app already exists.')
param frontendAppExists bool = false

/* ------------------------ AI Shopping Cart Service ------------------------ */

@description('Relative path to the AI shopping cart service JAR.')
param aiShoppingCartServiceRelativePath string

@description('Azure Open AI API key. This is required. Azure OpenAI is not deployed with this template.')
param azureOpenAiApiKey string

@description('Azure Open AI endpoint. This is required. Azure OpenAI is not deployed with this template.')
param azureOpenAiEndpoint string

@description('Azure Open AI deployment id. This is required. Azure OpenAI is not deployed with this template.')
param azureOpenAiDeploymentId string

@description('Set if the model deployed is Azure Open AI "gpt-4" (true) or "gpt-35-turbo" (false). Default is "gpt-4".')
param isAzureOpenAiGpt4Model bool = true

/* -------------------------------- Telemetry ------------------------------- */

@description('Enable usage and telemetry feedback to Microsoft.')
param enableTelemetry bool = true


/* -------------------------------------------------------------------------- */
/*                                  VARIABLES                                 */
/* -------------------------------------------------------------------------- */

@description('Abbreviations prefix for resources.')
var abbreviations = loadJsonContent('./abbreviations.json')

@description('Unique token used for global resource names.')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

@description('Name of the environment with only alphanumeric characters. Used for resource names that require alphanumeric characters only.')
var alphaNumericEnvironmentName = replace(replace(environmentName, '-', ''), ' ', '')

// tags that should be applied to all resources.
var tags = {
  // Tag all resources with the environment name.
  'azd-env-name': environmentName
}

//  Telemetry Deployment
@description('Enable usage and telemetry feedback to Microsoft.')
var telemetryId = '11d2e1bb-4e66-4a54-9d49-df3778d0e9a1-asaopenai-${location}'

/* ----------------------------- Resource Names ----------------------------- */

var _resourceGroupName = !empty(resourceGroupName) ? resourceGroupName : take('${abbreviations.resourcesResourceGroups}${environmentName}', 90)
var _containerAppsEnvironmentName = !empty(containerAppsEnvironmentName) ? containerAppsEnvironmentName : take('${abbreviations.appManagedEnvironments}${environmentName}', 60)
var _containerRegistryName = !empty(containerRegistryName) ? containerRegistryName : take('${abbreviations.containerRegistryRegistries}${alphaNumericEnvironmentName}${resourceToken}', 50)
var _logAnalyticsWorkspaceName = !empty(logAnalyticsWorkspaceName) ? logAnalyticsWorkspaceName : take('${abbreviations.operationalInsightsWorkspaces}${environmentName}', 63)
var _applicationInsightsName = !empty(applicationInsightsName) ? applicationInsightsName : take('${abbreviations.insightsComponents}${environmentName}', 255)
var _applicationInsightsDashboardName = !empty(applicationInsightsDashboardName) ? applicationInsightsDashboardName : take('${abbreviations.portalDashboards}${environmentName}', 160)
var _frontendContainerAppName = !empty(frontendContainerAppName) ? frontendContainerAppName : take('${abbreviations.appContainerApps}frontend-${environmentName}', 32)
var _springAppsInstanceName = !empty(springAppsInstanceName) ? springAppsInstanceName : take(toLower('${abbreviations.springApps}${environmentName}'), 32)
var _postgresFlexibleServerName = !empty(postgresFlexibleServerName) ? postgresFlexibleServerName : take(toLower('${abbreviations.dBforPostgreSQLServers}${environmentName}${resourceToken}'), 63)

/* -------------------------------------------------------------------------- */
/*                                  RESOURCES                                 */
/* -------------------------------------------------------------------------- */

// Organize resources in a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: _resourceGroupName
  location: location
  tags: tags
}

module containerAppsEnvironment 'core/host/container-apps-environment.bicep' = {
  name: _containerAppsEnvironmentName
  scope: resourceGroup
  params: {
    name: _containerAppsEnvironmentName
    location: location
    tags: tags
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
    applicationInsightsName: monitoring.outputs.applicationInsightsName
  }
}

module containerRegistry 'core/host/container-registry.bicep' = {
  name: _containerRegistryName
  scope: resourceGroup
  params: {
    name: _containerRegistryName
    location: location
    tags: tags
  }
}

module monitoring 'core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  scope: resourceGroup
  params: {
    location: location
    tags: tags
    logAnalyticsWorkspaceName: _logAnalyticsWorkspaceName
    applicationInsightsName: _applicationInsightsName
    applicationInsightsDashboardName: _applicationInsightsDashboardName
  }
}

module postgresFlexibleServer 'core/database/postgresql/flexible-server.bicep' = {
  name: _postgresFlexibleServerName
  scope: resourceGroup
  params: {
    name: _postgresFlexibleServerName
    location: location
    tags: tags
    postgresVersion: '15'
    sku: {
      name: 'Standard_B1ms'
      tier: 'Burstable'
    }
    storage: {
      storageSizeGB: 32
      autoGrow: 'Disabled'
    }
    administratorLogin: postgresAdminUsername
    administratorLoginPassword: postgresAdminPassword
    databaseNames: [
      environmentName
    ]
    allowAllIPsFirewall: true
    allowAzureIPsFirewall: true
  }
}

module frontend './app/frontend.bicep' = {
  name: 'frontend'
  scope: resourceGroup
  params: {
    name: _frontendContainerAppName
    location: location
    tags: tags
    identityName: _frontendContainerAppName
    aiShoppingCartServiceUri: aiShoppingCartService.outputs.SERVICE_AI_SHOPPING_CART_URI
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: containerAppsEnvironment.outputs.name
    containerRegistryName: containerRegistry.outputs.name
    exists: frontendAppExists
  }
}

module aiShoppingCartService 'app/ai-shopping-cart-service.bicep' = {
  name: 'ai-shopping-cart-service'
  scope: resourceGroup
  params: {
    name: _springAppsInstanceName
    location: location
    tags: tags
    // applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: containerAppsEnvironment.outputs.name
    relativePath: aiShoppingCartServiceRelativePath
    postgresFlexibleServerName: postgresFlexibleServer.outputs.name
    postgresDatabaseName: environmentName
    postgresAdminPassword: postgresAdminPassword
    azureOpenAiApiKey: azureOpenAiApiKey
    azureOpenAiEndpoint: azureOpenAiEndpoint
    azureOpenAiDeploymentId: azureOpenAiDeploymentId
    isAzureOpenAiGpt4Model: isAzureOpenAiGpt4Model
  }
}

resource telemetrydeployment 'Microsoft.Resources/deployments@2021-04-01' = if (enableTelemetry) {
  name: telemetryId
  location: location
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
      contentVersion: '1.0.0.0'
      resources: {}
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                                   OUTPUTS                                  */
/* -------------------------------------------------------------------------- */

// Outputs are automatically saved in the local azd environment .env file.
// To see these outputs, run `azd env get-values`,  or `azd env get-values --output json` for json output.

@description('The location of all resources.')
output AZURE_LOCATION string = location

@description('The id of the tenant.')
output AZURE_TENANT_ID string = tenant().tenantId

@description('The endpoint of the container registry.')
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerRegistry.outputs.loginServer

@description('The URI of the frontend.')
output SERVICE_FRONTEND_URI string = frontend.outputs.SERVICE_FRONTEND_URI
