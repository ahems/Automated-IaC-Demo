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

1. **Fork The Repo**

   First, you will need to **fork this repo** to your own GitHub account.

2. **Create a Service Principal**

   Then, you need to create a Service Principal with the right permissions to run the script:

   ```shell
   az ad sp create-for-rbac --name "github-action-sp" --role contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
   ```

   This command will output the following values:

   * appId: This is your AZURE_CLIENT_ID.
   * tenant: This is your AZURE_TENANT_ID.
   * password: This is the AZURE_CLIENT_SECRET. 
   * subscriptionId: This is your AZURE_SUBSCRIPTION_ID.

3. **Set Secrets in GitHub**

   Add the retrieved values as secrets in your GitHub repository. Follow these steps:

   * Go to your repository on GitHub.
   * Navigate to Settings > Secrets and variables > Actions.
   * Add the following secrets:
     
     * AZURE_CLIENT_ID: Use the appId from Step 2.
     * AZURE_TENANT_ID: Use the tenant from Step 2.
     * AZURE_SUBSCRIPTION_ID: Use the subscriptionId from Step 2.
     * AZURE_CLIENT_SECRET: Use the password from Step 2.

4. ** Run the Action

   Finally, you can run this action to have it deploy the IaC. This step itself could be automated too but to run it manually:

   * Go to your repository on GitHub.
   * Navigate to the Actions tab.
   * You should see the workflow named "Deploy To Azure from IaC" listed under "All workflows".
   * Initiate a new run, entering a value for username.