#! /bin/bash
git config --global url.https://oauth2:${GIT_PAT}@github.com/.insteadOf https://github.com/

# Display the version of TF we are using
terraform --version

# Initialise the TF state
terraform init -backend-config=bucket="${S3_BUCKET_NAME}" \
-backend-config=key="${TFSTATE}" \
-backend-config=dynamodb_table="${TFLOCKS}" \
-backend-config=region="eu-west-2" --reconfigure --upgrade

# Do a TF plan
terraform plan -out terraform.plan

# Do a TF apply, with auto approve and using the plan generated by the TF plan stage
terraform apply -auto-approve terraform.plan
