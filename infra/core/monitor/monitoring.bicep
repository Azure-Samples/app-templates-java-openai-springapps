targetScope = 'resourceGroup'

param logAnalyticsWorkspaceName string
param applicationInsightsName string
param applicationInsightsDashboardName string
param location string = resourceGroup().location
param tags object = {}
param includeDashboard bool = true

// TODO update deployment names

module logAnalyticsWorkspace 'log-analytics-workspace.bicep' = {
  name: 'logAnalyticsWorkspace'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

module applicationInsights 'application-insights.bicep' = {
  name: 'applicationinsights'
  params: {
    name: applicationInsightsName
    location: location
    tags: tags
    dashboardName: applicationInsightsDashboardName
    includeDashboard: includeDashboard
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
  }
}

output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey
output applicationInsightsName string = applicationInsights.outputs.name
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.id
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.outputs.name
