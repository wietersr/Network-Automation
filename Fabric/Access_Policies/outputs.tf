/*
     
    author: Rob Wieters

    usage:

      Output values make information about your infrastructure available on the command line, 
      and can expose information for other Terraform configurations to use. Output values are 
      similar to return values in programming languages.

      One often overlooked use-case for outputs is for troubleshooting the value of a variable.

        output "id" {
            value = "uni/grp-${var.group_name}"
            description = "You can briefly describe the output value for later recall"
        }

      references:
      - https://www.terraform.io/docs/language/values/outputs.html

output "lambda_role_id" {
description = "Unique ID of the role attached to the lambda function"
value = module.lambda_iam_role.id
}
*/




