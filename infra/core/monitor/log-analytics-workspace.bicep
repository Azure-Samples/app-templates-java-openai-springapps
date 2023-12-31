targetScope = 'resourceGroup'

param name string
param location string = resourceGroup().location
param tags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

output id string = logAnalyticsWorkspace.id
output name string = logAnalyticsWorkspace.name
