/*
    author: Rob Wieters

    usage:

      Provider definition: The provider establishes API communication and exposes resources.
      It is downloaded when you run  `terraform init` for the first time. This file specifies 
      the source and version of the provider. However, we variablize the details to facilitate
      code reuse.

      We reference input variables as URL, username, and password, which are defined as variables:

         - as specified in `credentials.auto.tfvars`
         - as a default value in `variables.tf`
         - and as an environment variable on the host
      
      Setting environment variables: When Terraform runs, it looks in your environment for 
      variables that match the pattern TF_VAR_<VARIABLE_NAME>, and assigns those values to 
      the corresponding Terraform variables in your configuration.

         - run: export TF_VAR_db_username=admin TF_VAR_db_password=adifferentpassword
         - run: terraform apply to assign the values to the variables

      Setting insecure to 'false' will flag an error if signed certificates are in use
         Error: Post "https://sandboxapicdc.cisco.com/api/aaaLogin.json": x509: certificate
         signed by unknown authority using a self-signed certificate

    references:
      - https://www.terraform.io/docs/configuration/providers.html
      - https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs
      - https://learn.hashicorp.com/tutorials/terraform/sensitive-variables#set-values-with-environment-variables

*/

provider "aci" {
  username = var.apic_username
  password = var.apic_password
  url      = var.url
  insecure = true
}