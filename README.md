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

   Finally, you can run this action to have it deploy the IaC. To run this step manually:

   * Go to your repository on GitHub.
   * Navigate to the Actions tab.
   * You should see the workflow named "Deploy To Azure from IaC" listed under "All workflows".
   * Initiate a new run, entering a value for username.

   To run this step automatically, get a [PAT] (https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) and use it to call the GitHub API via HTTPS. Here is an example of how to do this using curl:

   ```shell
   curl -X POST "https://api.github.com/repos/ahems/Automated-IaC-Demo/actions/workflows/deploy-IaC.yml/dispatches" -H "Accept: application/vnd.github.v3+json" -H "Authorization: Bearer <Your GitHub PAT>" -H "Content-Type: application/json" -d "{\"ref\": \"main\", \"inputs\": {\"username\": \"adamhems\"}}"
   ```
