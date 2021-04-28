/*
    
    author: Rob Wieters

    usage:

      Store the tfstate file in AWS S3 Bucket for version control and using DynamoDB table with 
      locking enabled. This method enables state file sharing across multiple users in a shared
      environment.

      To refresh the state, use the `terraform refresh` command. A tutorial on state can be found
      at https://www.terraform.io/docs/state/index.html

    references:
      - https://www.terraform.io/docs/backends/types/s3.html
      - https://www.terraform.io/docs/backends/config.html
*/


terraform {
  backend "s3" {
    bucket         = "corporate-s3-us-east-1-bts-dev-s3-aci"
    key            = "acisimulator/Tenant/TnYellow/state.tfstate"    # Path to the state file inside the S3 Bucket
    region         = "us-east-1"
    role_arn       = "arn:aws:iam::0123467890:role/account_admin"
    dynamodb_table = "aci-temp-tf-lock-table"
    
    # Using the aws arn to authenticate. Otherwise, access & secret keys (created in aws) 
    # could be used
    # access_key = "1234"                  # specified in file credentials_backend.tf
    # secret_key = "1234"                  # specified in file credentials_backend.tf
  }
}

    