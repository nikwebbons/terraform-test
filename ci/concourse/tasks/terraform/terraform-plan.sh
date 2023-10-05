#! /bin/bash
set -e
git config --global url.https://oauth2:${GIT_PAT}@github.com/.insteadOf https://github.com/

# Display the version of TF we are using
terraform --version

ls

# Initialise the TF state
terraform init -backend-config=bucket="${S3_BUCKET_NAME}" \
-backend-config=key="${TF_STATE}" \
-backend-config=dynamodb_table="${TF_LOCKS}" \
-backend-config=region="eu-west-2" --reconfigure --upgrade

# Do a TF plan
terraform plan -var-file=${TF_VARS} -out terraform.plan

cp -r . ../terraform-output
