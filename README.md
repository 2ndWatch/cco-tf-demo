# Terraform/Atlantis Demo for Clear Channel Outdoor

## Prerequisites
### 1. Deploy Infrastructure
1. You must have an IAM user set up with the following IAM policies attached:
    * PowerUser
		* IAMFullAccess
2. Generate access credentials (in the form of a user access key and a secret key) for the above user.
3. Use the following commands to tell Terraform to deploy infrastructure with your user:
    * `export AWS_ACCESS_KEY_ID=<access key from above step>`
		* `export AWS_SECRET_ACCESS_KEY=<secret access key>`
4. Change into the infrastructure directory using `cd infrastructure`.
5. `terraform init`
6. `terraform plan -var-file=staging.tfvars`
7. After verifying everything looks good from the above plan, run a `terraform apply -var-file=staging.tfvars` and confirm.
8. Make sure infrastructure deploys correctly.


### 2. Deploy Atlantis
1. Configure the following environment variables so you are not passing these variables as plaintext in to this Github repository:
    * `export TF_VAR_github_user_token=<[how to generate github user tokens](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/#creating-a-token)>`
		* `export TF_VAR_github_webhook_secret=<generate secret [here](https://www.browserling.com/tools/random-string)>`
2. Change into the Atlantis directory using `cd atlantis`.
3. `terraform plan` (no environment file this time as it's using the infrastructure you set up above)
4. `terraform apply`
5. Make sure infrastructure deploys correctly.
