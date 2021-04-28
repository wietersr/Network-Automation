/*
    author: Rob Wieters

    usage:
 
      To declare variables use the variable block in one of your .tf files, such as `variables.tf`.
      
      Input variables are used as arguments for a Terraform module. If you are familiar with Python data types, 
      the Terraform varaible block allows you to specify the data type of the variable, e.g. string, number, set, etc.

      However, the default values can be declared and used in the variable block. 

      In this file, we define varibles for the main module, and any sub module(s) if present in ./modules.

    references:
      - https://www.terraform.io/docs/configuration/variables.html

*/

#  Main module definitions
#
variable "apic_username" {
  description = "basic authentication for APIC"
  default = "admin"
  type = string
}

variable "url" {
  description = "URL of the APIC--Defaults to always-on ACI sandbox if none present"
  default = "https://sandboxapicdc.cisco.com/"
  type = string
}

variable "apic_password" {
  description = "basic authentication for APIC--defaults to always-on ACI sandbox in none present"
  default = "ciscopsdt"
  type = string
}

# Set variable declaration for VRFs
variable "ylw_vrf_set" {
    type        = set (string)
}

# Map variable declaration for BDs
variable "bd_map" {
  type = map(object( {
    subnet      = string
    vrf         = string
  }))
}

# Set variable declaration for APs
variable "ap_set" {
    type        = set (string)
}

# Map variable declaration for EPGs
variable "epg_map" {
  type = map(object( {
    physdomain_dn   = string
    ap          = string
    bd          = string
    name_alias  = string
#    vlan        = string
  }))
}