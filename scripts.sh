#!/bin/bash

# VARIABLES
export APP_NAME="jungle-hunt"
export PACKER_DIR="packer"
export TERRAFORM_DIR="terraform"

# PACKER
alias packer-${APP_NAME}="cd ${PACKER_DIR}"
alias packer-${APP_NAME}-test="packer-${APP_NAME} && packer validate -var-file=variables.json template.json && cd ../"
alias packer-${APP_NAME}-build="packer-${APP_NAME} && packer build -var-file=variables.json template.json && cd ../"

# TERRAFORM
alias terraform-${APP_NAME}="cd ${TERRAFORM_DIR}"

# DEV
alias terraform-${APP_NAME}-test-dev="terraform-${APP_NAME} && terraform plan -var-file='definitions.dev.tfvars' && cd ../"
alias terraform-${APP_NAME}-build-dev="terraform-${APP_NAME} && echo 'yes' | terraform apply -var-file='definitions.dev.tfvars' && cd ../"

# PROD
alias terraform-${APP_NAME}-test-dev="terraform-${APP_NAME} && terraform plan -var-file='definitions.prod.tfvars' && cd ../"
alias terraform-${APP_NAME}-build-dev="terraform-${APP_NAME} && echo 'yes' | terraform apply -var-file='definitions.prod.tfvars' && cd ../"

# SHORTCUTS
alias p-test="packer-${APP_NAME}-test"
alias p-build="packer-${APP_NAME}-build"
alias tf-test-dev="terraform-${APP_NAME}-test-dev"
alias tf-build-dev="terraform-${APP_NAME}-build-dev"
alias tf-test-prod="terraform-${APP_NAME}-test-prod"
alias tf-build-prod="terraform-${APP_NAME}-build-prod"
