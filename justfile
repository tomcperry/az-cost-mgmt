set dotenv-load := true

# prints usage for this justfile
usage:
    @echo "This is placeholder to workaround how just runs the first recipe if one if not specified."
    @echo "To see available recipes, run 'just --list' or 'just -l'."

# runs the interactive azure login flow
login:
    az login

# runs a what-if deployment to preview changes
whatif:
    az deployment sub create --what-if --location "${AZ_LOCATION}" --subscription "${AZ_SUBSCRIPTION_ID}" --template-file ./infrastructure/main.bicep --parameters ./infrastructure/parameters.bicepparam

# deploys the azure stack to the subscription in the environment variable 'AZ_SUBSCRIPTION_ID'
deploy:
    az stack sub create --location "${AZ_LOCATION}" --subscription "${AZ_SUBSCRIPTION_ID}" --template-file ./infrastructure/main.bicep --parameters ./infrastructure/parameters.bicepparam --name "cost-mgmt" --action-on-unmanage deleteAll --deny-settings-mode none --yes
