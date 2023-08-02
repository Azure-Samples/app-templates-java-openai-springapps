targetScope = 'resourceGroup'

/* -------------------------------------------------------------------------- */
/*                                 PARAMETERS                                 */
/* -------------------------------------------------------------------------- */

@description('Name of the Spring Apps instance to deploy.')
param name string

@description('Location in which the resources will be deployed. Default value is the resource group location.')
param location string = resourceGroup().location

@description('Tags that will be added to all the resources. For Azure Developer CLI, "azd-env-name" should be added to the tags.')
param tags object = {}

// param applicationInsightsName string

@description('Name of the existing Container Apps Environment in which the Spring Apps instance is deployed.')
param containerAppsEnvironmentName string

@description('Name of the Spring App. This name is used to add "azd-service-name" to the tags for the Spring Apps Instance. This is required for Azure Developer CLI to know which service to deploy. Default value is "ai-shopping-cart-service". If you change this value, make sure to change the name of the service in "azure.yaml" file as well.')
param appName string = 'ai-shopping-cart-service'

@description('Relative path to the AI shopping cart service JAR.')
param relativePath string

/* ------------------------------- PostgreSQL ------------------------------- */

@description('Name of the existing Postgres Flexible Server. This is the relational database used by the Spring App to save the state of the shopping cart.')
param postgresFlexibleServerName string

@description('Name of the Postgres database. Several databases can be created in the same Postgres Flexible Server. We need to know the one that is created for this microservice.')
param postgresDatabaseName string

@secure()
@description('Password of the Postgres Flexible Server administrator. This is the password that was set when the Postgres Flexible Server was created.')
param postgresAdminPassword string

/* --------------------------------- OpenAI --------------------------------- */

@description('Azure Open AI API key.')
param azureOpenAiApiKey string

@description('Azure Open AI endpoint.')
param azureOpenAiEndpoint string

@description('Azure Open AI deployment ID.')
param azureOpenAiDeploymentId string

@description('Set if the model deployed is Azure Open AI "gpt-4" (true) or "gpt-35-turbo" (false).')
param isAzureOpenAiGpt4Model bool

/* -------------------------------------------------------------------------- */
/*                                  VARIABLES                                 */
/* -------------------------------------------------------------------------- */

@description('Spring Data Source URL. It is composed of the Postgres Flexible Server FQDN and the database name.')
var springDatasourceUrl =  'jdbc:postgresql://${postgresFlexibleServer.properties.fullyQualifiedDomainName}:5432/${postgresDatabaseName}?sslmode=require'

/* -------------------------------------------------------------------------- */
/*                                  RESOURCES                                 */
/* -------------------------------------------------------------------------- */

resource postgresFlexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2023-03-01-preview' existing = {
  name: postgresFlexibleServerName
}

module springApps '../core/host/spring-apps-consumption.bicep' = {
  name: name
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': appName })
    // applicationInsightsName: applicationInsightsName
    containerAppsEnvironmentName: containerAppsEnvironmentName
    appName: appName
    relativePath: relativePath
    environmentVariables: {
      SPRING_DATASOURCE_URL: springDatasourceUrl
      SPRING_DATASOURCE_USERNAME: postgresFlexibleServer.properties.administratorLogin
      SPRING_DATASOURCE_PASSWORD: postgresAdminPassword
      AZURE_OPENAI_API_KEY: azureOpenAiApiKey
      AZURE_OPENAI_ENDPOINT: azureOpenAiEndpoint
      AZURE_OPENAI_DEPLOYMENT_ID: azureOpenAiDeploymentId
      AZURE_OPENAI_IS_GPT4: isAzureOpenAiGpt4Model ? 'true' : 'false'
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                                   OUTPUTS                                  */
/* -------------------------------------------------------------------------- */

@description('Name of AI Shopping Cart Service Spring App.')
output SERVICE_AI_SHOPPING_CART_NAME string = springApps.outputs.springAppName

@description('URI of AI Shopping Cart Service Spring App.')
output SERVICE_AI_SHOPPING_CART_URI string = springApps.outputs.uri
