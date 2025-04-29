param location string = resourceGroup().location
param environmentName string = 'dev'
param tags object = {
  environment: environmentName
  createdBy: 'bicep'
}
param vnetName string = 'vnet'
param addressSpace array = [
  '10.0.0.0/16'
] // Address space for the virtual network
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'subnet2'
    addressPrefix: '10.0.1.0/24'
  }
]

module vnet 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'vnet'
  params: {
    location: location
    name: vnetName
    addressPrefixes: addressSpace
    subnets: subnets
    tags: tags
  }
}

output subnet1Id string = vnet.outputs.subnetResourceIds[0]
output subnet2Id string = vnet.outputs.subnetResourceIds[1]
