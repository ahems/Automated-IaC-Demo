# Automated-IaC-Demo
A demo repo that deploys some IaC automagically.

## Manual steps

First, authenticate:

```shell
az login
```

Then run the script:

```shell
az deployment sub create --name IaC-Demo --location eastus --template-file ./infra/main.bicep --parameters enablePublicIp=false --parameters username='azureuser'
```

## Via Automation

You need to create a Service Principal with the right permissions to run the script:

```shell
az ad sp create-for-rbac --name "github-action-sp" --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

This command will output the following values:

appId: This is your AZURE_CLIENT_ID.
tenant: This is your AZURE_TENANT_ID.
password: This is the client secret (not needed for federated credentials).
subscriptionId: This is your AZURE_SUBSCRIPTION_ID.

Next, enable Federated Credentials:

```shell
az identity federated-credential create \
  --name "github-actions-federated-credential" \
  --identity-name "github-action-sp" \
  --resource-group <RESOURCE_GROUP_NAME> \
  --issuer "https://token.actions.githubusercontent.com" \
  --subject "repo:<OWNER>/<REPO>:ref:refs/heads/<BRANCH>" \
  --audiences "api://AzureADTokenExchange"
```

Use the Azure CLI to retrieve the federated token:

```shell
az account get-access-token --resource https://management.azure.com
```

The output will include an accessToken, which you can use as the AZURE_FEDERATED_TOKEN.

Set Secrets in GitHub
Add the retrieved values as secrets in your GitHub repository:

Go to your repository on GitHub.
Navigate to Settings > Secrets and variables > Actions.
Add the following secrets:
AZURE_CLIENT_ID: Use the appId from Step 2.
AZURE_TENANT_ID: Use the tenant from Step 2.
AZURE_SUBSCRIPTION_ID: Use the subscriptionId from Step 2.
AZURE_FEDERATED_TOKEN: Use the accessToken from Step 4.