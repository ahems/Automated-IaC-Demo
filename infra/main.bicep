targetScope = 'subscription'



@minLength(1)
@description('Username for the environment')
@maxLength(8)
param username string
var environmentName = '${username}-${uniqueString(subscription().id, location)}'

@minLength(1)
@description('Primary location for all resources')
param location string = 'eastus'

var abbrs = loadJsonContent('./abbreviations.json')

param tags object = {
  environment: '${username}-${uniqueString(subscription().id, location)}'
}

@description('Name of the resource group')
var resourceGroupName = 'rg-${environmentName}'

@description('Name of the virtual network')
var vnetName = '${abbrs.networkVirtualNetworks}${environmentName}'

@description('Name of the first subnet')
var subnet1Name = '${abbrs.networkVirtualNetworksSubnets}${environmentName}-1'

@description('Name of the second subnet')
var subnet2Name = '${abbrs.networkVirtualNetworksSubnets}${environmentName}-2'

@description('Name of the virtual machine')
var vmName = '${abbrs.computeVirtualMachines}${environmentName}'

var subnets = [
  {
    name: subnet1Name
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: subnet2Name
    addressPrefix: '10.0.1.0/24'
  }
]

var addressSpace = [
  '10.0.0.0/16'
]

var sshKeyName = 'sshKey-${environmentName}'
var pipName = 'pip-${environmentName}'

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

module vnet 'modules/vnet.bicep' = {
  name: 'CreateVnet'
  scope: rg
  params: {
    location: location
    environmentName: environmentName
    tags: tags
    vnetName: vnetName
    addressSpace: addressSpace
    subnets: subnets
  }
}

module sshKey 'br/public:avm/res/compute/ssh-public-key:0.4.3' = {
  name: 'sshKey'
  scope: rg
  params: {
    location: location
    name: sshKeyName
    tags: tags
  }
}

module vm 'modules/vm.bicep' = {
  name: 'CreateVm'
  scope: rg
  params: {
    location: location
    vmName: vmName
    subnetResourceId: vnet.outputs.subnet1Id
    adminUsername: guid(subscription().id)
    adminPassword: guid(resourceGroupName)
    disablePasswordAuthentication: false
    pipName: pipName
  }
}
