param location string = resourceGroup().location
@description('Name of the SSH key')
@minLength(1)
@maxLength(64)
param sshKeyName string = 'sshKey-${uniqueString(resourceGroup().id, location)}'

@description('Tags for the SSH key')
param tags object

module sshKey 'br/public:avm/res/compute/ssh-public-key:0.4.3' = {
  name: 'sshKey'
  params: {
    location: location
    name: sshKeyName
    tags: tags
  }
}
