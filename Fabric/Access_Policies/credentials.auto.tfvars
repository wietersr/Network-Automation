/*
    
    author: Rob Wieters

    usage:

        Any files with names ending in .auto.tfvars or .auto.tfvars.json are loaded automatically
        A .tfvars file is used to assign values to variables that have already been declared in .tf files.
        Single quotes are not valid. Use double quotes (") to enclose strings.
        You can define variable values in environment variables, but the precedence is the last value found,
        To specify the APIC password as an environment variable, issue the shell command:
        $ export TF_VAR_apic_password="changeme"
        The variable `apic_username` is specified in this file, the associated password will be provided as an
        environment variable.

    references:
      - https://www.terraform.io/docs/configuration/variables.html#assigning-values-to-root-module-variables
      - https://www.terraform.io/docs/configuration/variables.html#variable-definition-precedence

*/

# ALWAYS-ON ACI SANDBOX
apic_username = "admin"
apic_password = "ciscopsdt"
url           = "https://sandboxapicdc.cisco.com" #alwayson ACI sandbox

# # ACI SIMULATOR (VM APPLIANCE at DDC)    
# apic_username = "admin"
# apic_password = "ACIsim2021"
# url           = "https://10.x.x.x"
    
# # PRODUCTION ACI FABRIC
# apic_username = "apic:Domain\\\\admin"
# #apic_password = "leave blank & commented out" # with no pw present, system will prompt for pw
# url           = "https://172.x.x.x"
