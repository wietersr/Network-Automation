/*
    author: Rob Wieters

    usage:
 
      To set lots of variables, it is more convenient to specify their values in a variable definitions 
      file (with a filename ending in either .tfvars or .tfvars.json). If a use case presents itself,
      one could also specify a tfvars file on the command line with -var-file: terraform apply -var-file="testing.tfvars"

      Note: This is how Terraform Cloud passes workspace variables to Terraform.
      Note: This is also how you limit the exposure to code. Teammates with little code knowledge can focus
            their updates on the tfvars file(s) to change configuration.

      A variable definitions file uses the same basic syntax as Terraform language files, but consists 
      only of variable name assignments:

    references:
      - https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files

*/

# List of VRF's in the tenant
ylw_vrf_set = [
    "NonProd-VRF",
    "BTS_Prod-VRF",
    "SCS_Prod-VRF",
    "EBZ_Prod-VRF",
    "ADCS_Prod-VRF",
    "ADCE_Prod-VRF",
    "ADCE_PCI_Prod-VRF"
]

# Map of objects: Bridge Domains, Subnet assignment for each bd, and related VRF
bd_map = {
    "BTS_NonProd_Database_Svc" = {
        subnet = "192.168.0.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_FnP_Svc" = {
        subnet = "192.168.1.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_DFS_Svc" = {
        subnet = "192.168.2.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_Messaging_Svc" = {
        subnet = "192.168.3.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_CRM_Svc" = {
        subnet = "192.168.4.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_InfoSec_Svc" = {
        subnet = "192.168.5.1/24"
        vrf    = "NonProd-VRF"
        }
    "BTS_NonProd_Firewall_Mgt_Svc" = {
        subnet = "192.168.6.1/24"
        vrf    = "NonProd-VRF"
        }
    }

# List of Application Profiles in the Tenant
ap_set = [
    "ADCE_PCI_Prod-AP",
    "ADCE_Prod-AP",
    "ADCS_Prod-AP",
    "BTS_Prod-AP",
    "EBZ_Prod-AP",
    "Non-Prod-AP",
    "NProd_BTS-AP",
    "SCS_Prod-AP"
]

# Map of objects defining the End Point Groups, their name_alias, related application profile, 
# bridge domain and physical domain
 epg_map = {
     "BTS_NonProd_Database_Svc_10.8.0.0" = {
        name_alias     = "10.8.0.0_24_VL2000"
        ap             = "Non-Prod-AP"
        bd             = "BTS_NonProd_Database_Svc"
        physdomain_dn  = "uni/phys-Prod_Network-PhyDom"
     }
     "BTS_NonProd_FnP_Svc_10.8.1.0" = {
        name_alias     = "10.8.1.0_24_VL2001"
        ap             = "Non-Prod-AP"
        bd             = "BTS_NonProd_FnP_Svc"
        physdomain_dn  = "uni/phys-Prod_Network-PhyDom"
     }
     "BTS_NonProd_DFS_Svc_10.8.2.0" = {
        name_alias     = "10.8.2.0_24_VL2002"
        ap             = "Non-Prod-AP"
        bd             = "BTS_NonProd_DFS_Svc"
        physdomain_dn  = "uni/phys-Prod_Network-PhyDom"
        }
    "BTS_NonProd_Messaging_Svc_10.8.3.0" = {
		name_alias     = "10.8.3.0_24_VL2003"
		ap             = "Non-Prod-AP"
		bd             = "BTS_NonProd_Messaging_Svc"
		physdomain_dn  = "uni/phys-Prod_Network-PhyDom"
	}
    "BTS_NonProd_CRM_Svc_10.8.4.0" = {
		name_alias    = "10.8.4.0_24_VL2004"
		ap            = "Non-Prod-AP"
		bd            = "BTS_NonProd_CRM_Svc"
		physdomain_dn = "uni/phys-Prod_Network-PhyDom"
	}
    "BTS_NonProd_InfoSec_Svc_10.8.5.0" = {
		name_alias    = "10.8.5.0_24_VL2005"
		ap            = "Non-Prod-AP"
		bd            = "BTS_NonProd_InfoSec_Svc"
		physdomain_dn = "uni/phys-Prod_Network-PhyDom"
	}
    "BTS_NonProd_Firewall_Mgt_Svc_10.8.6.0" = {
		name_alias    = "10.8.6.0_24_VL2006"
		ap            = "Non-Prod-AP"
		bd            = "BTS_NonProd_Firewall_Mgt_Svc"
		physdomain_dn = "uni/phys-Prod_Network-PhyDom"
	}
}