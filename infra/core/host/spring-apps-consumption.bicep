targetScope = 'resourceGroup'

/* -------------------------------------------------------------------------- */
/*                                 PARAMETERS                                 */
/* -------------------------------------------------------------------------- */

@description('Name of the Spring Apps instance to deploy.')
param name string

@description('Location in which the resources will be deployed. Default value is the resource group location.')
param location string = resourceGroup().location

@description('Tags to associate with the Spring Apps instance.')
param tags object = {}

// @description('Name of the existing Application Insights instance to use for this Spring Apps platform to deploy.')
// param applicationInsightsName string

@description('Name of the existing container apps environment to use for this Spring Apps platform to deploy.')
param containerAppsEnvironmentName string

@minLength(4)
@maxLength(32)
@description('Name of the Spring App to deploy.')
param appName string

@description('Relative path to the JAR file to deploy.')
param relativePath string

@description('Environment variables to set for the Spring App. Default value is an empty object.')
param environmentVariables object = {}

/* -------------------------------------------------------------------------- */
/*                                  RESOURCES                                 */
/* -------------------------------------------------------------------------- */

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2023-04-01-preview' existing = {
  name: containerAppsEnvironmentName
}

// resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
//   name: applicationInsightsName
// }

resource springApps 'Microsoft.AppPlatform/Spring@2023-05-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'S0'
    tier: 'StandardGen2'
  }
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    zoneRedundant: false
  }
}

resource springApp 'Microsoft.AppPlatform/Spring/apps@2023-05-01-preview' = {
  name: appName
  location: location
  parent: springApps
  properties: {
    public: true
    workloadProfileName: 'Consumption'
  }
}

resource springAppDeployment 'Microsoft.AppPlatform/Spring/apps/deployments@2023-05-01-preview' = {
  name: 'default'
  parent: springApp
  properties: {
    source: {
      type: 'Jar'
      relativePath: relativePath
      runtimeVersion: 'Java_17'
      jvmOptions: '-Xms1024m -Xmx2048m'
    }
    deploymentSettings: {
      resourceRequests: {
        cpu: '1'
        memory: '2Gi'
      }
      scale: {
        minReplicas: 1
        maxReplicas: 1
      }
      environmentVariables:  environmentVariables
    }
  }
}

// resource springAppsMonitoringSettings 'Microsoft.AppPlatform/Spring/monitoringSettings@2023-05-01-preview' = {
//   name: 'default'
//   parent: springApps
//   properties: {
//     appInsightsInstrumentationKey: applicationInsights.properties.InstrumentationKey
//     appInsightsSamplingRate: 88
//   }
// }

/* -------------------------------------------------------------------------- */
/*                                   OUTPUTS                                  */
/* -------------------------------------------------------------------------- */

@description('Name of the Spring Apps instance.')
output springAppsInstanceName string = springApps.name

@description('Name of the Spring App.')
output springAppName string = springApp.name

@description('URI of the Spring App.')
output uri string = springApp.properties.url
