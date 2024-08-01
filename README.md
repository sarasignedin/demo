# entelligence-interview

## Get Started
Login into your AWS account and generate AWS credentials. Then configure your AWS CLI with:
```
aws configure
```

Here are instructions on installing AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Now install the`terraform` CLI. You can find instructions here: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## 1 - bootstrap
This Terraform code stages S3 resources that we'll use as test cases for our IAM resources. It also creates the new user `dev-user-1`.

To run this code:
```sh
cd 1-bootstrap/
terraform init
terraform apply -auto-approve
```

## 2 - IAM User
Provision the IAM group and policy to meet the following conditions:

Initially the developer should be able to have read/write access to ecommerce objects in dev, but after 6 months of their hire date, the developer should be granted the same rights to the stage environment.

Also, adds user to IAM group.

To run this code:
```sh
cd 2-iam/
terraform init
terraform apply -auto-approve
```

## Testing
To test:
- Generate access key credentials for the new user that was created in your account (`dev-user-1`)
- Configure your aws CLI to use those new credentials by adding the following to your ~/.aws/credentials file:
```
[dev-user-1]
aws_access_key_id = <YOUR_AWS_ACCESS_KEY_ID>
aws_secret_access_key = <YOUR_AWS_SECRET_ACCESS_KEY>
```
- Run the following s3 commands:
  - `aws --profile dev-user-1 s3 ls s3://dev-ecommerce-${random_string}`
    - This should succeed
  - `aws --profile dev-user-1 s3 ls s3://dev-infra-${random_string}`
    - This should fail
  - `aws --profile dev-user-1 s3 ls s3://stage-ecommerce-${random_string}`
    - This should fail initially. To test it works, update the variable `stage_access_after` to a value that is prior to today's date and re-run the terraform. Then re-run the `aws` command for the bucket.
  - `aws --profile dev-user-1 s3 ls s3://stage-neteng-${random_string}`
    - This should fail
  - `aws --profile dev-user-1 s3 ls s3://prod-ecommerce-${random_string}`
    - This should fail
  - `aws --profile dev-user-1 s3 ls s3://prod-security-${random_string}`
    - This should fail


## Diagram
![alt text](diagram.png "Diagram")