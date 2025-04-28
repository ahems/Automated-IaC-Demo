# Automated-IaC-Demo
A demo repo that deploys some IaC automagically.

## Manual steps

First, authenticate:

```shell
az login
```

Then run the script:

```shell
az deployment sub create --name IaC-Demo --location eastus --template-file ./infra/main.bicep
```

## Via Automation
