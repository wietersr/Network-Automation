/*
    
    author: Rob Wieters

    usage:

      This defines the provider, source, and version information for the sirectory structure.

    references:
      - https://www.terraform.io/docs/language/providers/requirements.html#version-constraints

*/

# Provider declaration
terraform {
    required_providers {
      aci = {
          source  = "CiscoDevNet/aci"
          version = "0.5.4"
      }
    }
}