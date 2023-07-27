targetScope = 'resourceGroup'

/* -------------------------------------------------------------------------- */
/*                                 PARAMETERS                                 */
/* -------------------------------------------------------------------------- */

@description('Name of the container apps environment.')
param name string

@description('Location in which the container apps environment will be deployed. Default value is the resource group location.')
param location string = resourceGroup().location

@description('Tags to associate with the container apps environment. Defaults to an empty object ({}).')
param tags object = {}

@description('Name of the existing application insights instance to use for the container apps environment. If the name is not provided, Dapr telemetry will be disabled even if "enableDaprTelemetry" is set to true.')
param applicationInsightsName string = ''

@description('Set if Dapr telemetry is enabled.')
param enableDaprTelemetry bool = false

@description('Name of the existing log analytic workspace to use for the container apps environment.')
param logAnalyticsWorkspaceName string

/* -------------------------------------------------------------------------- */
/*                                  RESOURCES                                 */
/* -------------------------------------------------------------------------- */

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = if (enableDaprTelemetry && !empty(applicationInsightsName)) {
  name: applicationInsightsName
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-04-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    vnetConfiguration: {
      internal: false
    }
    zoneRedundant: false
    workloadProfiles: [
      {
        workloadProfileType: 'Consumption'
        name: 'Consumption' 
      }
    ]
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWorkspace.properties.customerId
        sharedKey: logAnalyticsWorkspace.listKeys().primarySharedKey
      }
    }
    daprAIInstrumentationKey: enableDaprTelemetry && !empty(applicationInsightsName) ? applicationInsights.properties.InstrumentationKey : ''
  }
}

/* -------------------------------------------------------------------------- */
/*                                   OUTPUTS                                  */
/* -------------------------------------------------------------------------- */

@description('The name of the container apps environment.')
output name string = containerAppsEnvironment.name
