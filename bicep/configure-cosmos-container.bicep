@description('Name of the Cosmos DB account')
param cosmosDbAccountName string

@description('Name of the Cosmos DB database')
param databaseName string

@description('Name of the Cosmos DB container')
param containerName string

@description('TTL value in seconds (use -1 to disable, or 7776000 for 90 days)')
param ttlInSeconds int = 7776000

@description('Enable Analytical Store (Synapse Link)')
param enableAnalyticalStore bool = true

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' existing = {
  parent: cosmosDb
  name: databaseName
}

resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: '${databaseName}/${containerName}'
  parent: cosmosDbDatabase
  properties: {
    resource: {
      id: containerName
      defaultTtl: ttlInSeconds
      analyticalStorageTtl: enableAnalyticalStore ? -1 : 0
    }
    options: {}
  }
}
