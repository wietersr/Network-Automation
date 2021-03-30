# Provider declaration
terraform {
    required_providers {
      aci = {
          source  = "CiscoDevNet/aci"
          version = "0.5.4"
      }
    }
}

# Provider configuration
provider "aci" {
    username = "admin" 
    password = "ciscopsdt"
    url = "https://sandboxapicdc.cisco.com" #alwayson ACI sandbox
    insecure = true
}

#########################################################################
# Network Centric ACI Deployment via Terraform (last update 3/30)
#########################################################################

# One Tenant
resource "aci_tenant" "tnLocalName" {
  name = "YLW"
  name_alias = "Yellow"
}
  
# Multiple VRF's per Tenant:
# NonProd-VRF, BTS_NonProd-VRF, BTS_Prod-VRF, SCS_Prod-VRF
#----------------------------------------------
# Multiple Bridge Domains (VLAN = BD = EPG)
# Each Bridge Domain includes a subnet with public scope
# BTS_NonProd_Database_Svc (subnet 192.168.1.1/24), BTS_NonProd_FnP_Svc (subnet 192.168.2.1/24), 
# BTS_Prod_Database_Svc (subnet 192.168.3.1/24), BTS_Prod_FnP_Svc (subnet 192.168.4.1/24),
# SCS_Prod_Database_Svc (subnet 192.168.5.1/24), SCS_Prod_FnP_Svc (subnet 192.168.6.1/24),
#----------------------------------------------
# Each Bridge Domain includes a subnet with public scope (noted in BD section)
#----------------------------------------------
# Multiple Application Profiles (each associated to their prefixed EPG)
# NonProd-AP, BTS_Prod-AP, SCS_Prod-AP
#----------------------------------------------
# Multiple Application EPG's (each associated to their prefixed AP and appending their respective subnets as suffix)
# BTS_NonProd_Database_Svc_192.168.1.0, BTS_NonProd_FnP_Svc_192.168.2.0, 
# BTS_Prod_Database_Svc_192.168.3.0, BTS_Prod_FnP_Svc_192.168.4.0,
# SCS_Prod_Database_Svc_192.168.5.0, SCS_Prod_FnP_Svc_192.168.6.0,
#----------------------------------------------
# Each EPG is mapped to a physical domain: Prod_Network-PhyDom
#----------------------------------------------
# Each EPG is mapped to a Static Path Binding of pod: 1, switch1: 201, switch2: 202, vpc: NX01_02_Blk_vpc-intPG, encap: [vlanID]
#----------------------------------------------
# L3Out: each BD is associated to "NonProd" L3Out
  

  
