// Description: This module creates a virtual machine in Azure with the specified parameters.
// It uses the Azure Virtual Machine module from the Azure Bicep library.
// The module creates a virtual machine with the specified name, size, and operating system.
// It also creates a network interface, public IP address, and network security group.
// The module allows for customization of the virtual machine's properties, such as
// the operating system, size, and network configuration.

// Description: This module creates a virtual machine in Azure with the specified parameters.

@description('Location for the virtual machine')
param location string

@description('Name of the virtual machine')
param vmName string = 'default-vm'

@description('Admin username for the virtual machine')
param adminUsername string = 'azureuser'

@description('Admin password for the virtual machine (required if password authentication is enabled)')
@secure()
param adminPassword string

@description('Size of the virtual machine')
param vmSize string = 'Standard_D2s_v3'

@description('Operating system type (e.g., Linux or Windows)')
param osType string = 'Linux'

@description('Image reference for the virtual machine')
param imageReference object = {
  offer: '0001-com-ubuntu-server-jammy'
  publisher: 'Canonical'
  sku: '22_04-lts-gen2'
  version: 'latest'
}

@description('Name of the network interface suffix')
param nicSuffix string = '-nic-01'

@description('Name of the public IP configuration')
param pipName string = 'pip-01'

@description('Subnet resource ID for the virtual machine')
param subnetResourceId string

@description('OS disk caching type')
param osDiskCaching string = 'ReadWrite'

@description('OS disk size in GB')
param osDiskSizeGB int = 128

@description('OS disk storage account type')
param osDiskStorageAccountType string = 'Premium_LRS'

@description('Availability zone for the virtual machine')
param zone int = 0

@description('Disable password authentication (set to true for SSH key authentication)')
param disablePasswordAuthentication bool = true

module vm 'br/public:avm/res/compute/virtual-machine:0.14.0' = {
  name: 'virtualMachineDeployment'
  params: {
    location: location
    name: vmName
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    osType: osType
    imageReference: imageReference
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: pipName
            pipConfiguration: {
              name: pipName
            }
            subnetResourceId: subnetResourceId
          }
        ]
        nicSuffix: nicSuffix
      }
    ]
    osDisk: {
      caching: osDiskCaching
      diskSizeGB: osDiskSizeGB
      managedDisk: {
        storageAccountType: osDiskStorageAccountType
      }
    }
    zone: zone
    disablePasswordAuthentication: disablePasswordAuthentication
  }
}
