/*
    
    author: Rob Wieters

    usage:
 
      To declare variables use the variable block in one of your .tf files, such as `variables.tf`.
      A .tfvars file is used to assign values to variables that have already been declared in .tf files.

      Input variables are used as arguments for a Terraform module. If you are familiar with Python data types, 
      the Terraform varaible block allows you to specify the data type of the variable, e.g. string, number, set, etc.

      However, the default values can be declared and used in the variable block. An example of this is
      the variable `apic_url`. The username and password of the APIC are specifed as environment variables
      and in `credentials.auto.tfvars`.

      In this file, we define varibles for the main module, and the sub-module, `lldp`.

    references:
      - https://www.terraform.io/docs/configuration/variables.html

*/
 
#
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
#
# Sub-module definitions for Fabric Access Policies 
# -------------------------------------------------

# Switches | Leaf Switches | [Leaf/node] Profiles (Single Switch Profiles)
variable "snodeprofile_map" {
  type = map(object( {
    snodeprof_name_alias      = string
    snodeprof_description     = string
    snodeprof_lfifprof_key    = set(string)
    snodeprof_selectorname    = string
    snodeprof_switchassc_type = string
    snodeprof_blockname       = string
    snodeprof_from_node       = number
    snodeprof_to_node         = number
  }))
}

# Switches | Leaf Switches | [Leaf] Profiles (Dual Switch Profiles)
variable "dnodeprofile_map" {
  type = map(object( {
    dnodeprof_name_alias        = string
    dnodeprof_description       = string
    dnodeprof_lfifprof_key      = set(string)
    dnodeprof_leafselector      = map(object({
      dnodeprof_switchassc_type = string
      dnodeprof_blockname       = string
      dnodeprof_from_node       = number
      dnodeprof_to_node         = number
    }))
  }))
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles
variable "lfprofile_map" {
  type = map(object( {
    lfprofile_name_alias      = string
    lfprofile_description     = string
  }))
}


# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors
variable "accportsel_map" {
  type = map(object( {
    lfprofile_key         = string
    lfsel_name_alias      = string
    ifsel_description     = string
    ifsel_type            = string
  }))
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups
variable "accportblk_map" {
  type = map(object( {
    lfselector_key        = string
    portblk_name          = string
    portblk_description   = string
    portblk_fromcard      = number
    portblk_fromport      = number
    portblk_tocard        = number
    portblk_toport        = number
  }))
}

variable "accessgrp_map" {
  type = map(object( {
    accgrp_lfselector_key      = string
    accgrp_policygrp_key       = string
    accgrp_type                = string
  }))
  
}

# Interfaces | Leaf Interfaces | Profiles | Leaf FEX Profiles
variable "lffexprofile_map" {
  type = map(object( {
    lffexprofile_name_alias      = string
    lffexprofile_description     = string
  }))
}

# Interfaces | Leaf Interfaces | Profiles | Leaf FEX Profiles | Leaf FEX Policy Groups
variable "lffexpolgrp_map" {
  type = map(object( {
    fexpolgrp__name_alias      = string
    fexpolgrp__description     = string
    fexpolgrp_key              = string
  }))
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors for fex
variable "fexaccportsel_map" {
  type = map(object( {
    fexprofile_key           = string
    fexifsel_description     = string
    fexifsel_type            = string
  }))
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups for fex
variable "fexaccportblk_map" {
  type = map(object( {
    fexlfselector_key        = string
    fexportblk_name          = string
    fexportblk_description   = string
    fexportblk_fromcard      = number
    fexportblk_fromport      = number
    fexportblk_tocard        = number
    fexportblk_toport        = number
  }))
}

variable "fexaccessgrp_map" {
  type = map(object( {
    fexaccgrp_lfselector_key      = string
    fexaccgrp_fexID               = number
    fexaccgrp_policygrp_key       = string
    #fexaccgrp_type                = string
  }))
  
}

/*
This code got too complicated, so went traditional route to build the leaf profile code using 
multiple resource blocks--may refactor at a later date to refine that into something more
efficient. leaving this parked here for later use and reference.

variable "lf_selectors_map" {
  type = map(object( {
    lfsel_name            = string
    lfsel_profile_list    = list(string)
    lfsel_description     = string
    # lfprofile_selector        = string
    # lfprofile_switchassctype  = string
    # lfprofile_blockname       = string
    lfsel_fromport        = number
    lfsel_toport          = number
    ifpolgrp_assc         = string
  }))
}
*/

# Interfaces | Leaf Interfaces | Overrides
variable "lfoverides_map" {
  type = map(object( {
    lfoverides_description    = string
    lfoverides_podID          = string
    lfoverides_nodeID         = string
    lfoverides_portID         = string
    lfoverides_portpolicygrp  = string
  }))
}

# Interfaces | Leaf Switches | Policy Groups | Leaf Access Ports
variable "lfaccptpolgrp_map" {
  type = map(object( {
    lfaccptpolgrp_name_alias         = string
    lfaccptpolgrp_description        = string
    #aaep_id                         = string
    #######################################################################
    ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #####
    #######################################################################
    #lfaccptpolgrp_spanVSrcGrp       = string
    #lfaccptpolgrp_stormctrlIfPol    = string
    #lfaccptpolgrp_poeIfPol          = string
    lfaccptpolgrp_lldpIfPol          = string
    #lfaccptpolgrp_macsecIfPol       = string
    #lfaccptpolgrp_qosDppPol         = string
    lfaccptpolgrp_fabricHIfPol       = string
    #lfaccptpolgrp_netflowMonitorPol = string
    #lfaccptpolgrp_l2PortAuthPol     = string 
    #lfaccptpolgrp_mcpIfPol          = string
    #lfaccptpolgrp_l2PortSecurityPol = string
    #lfaccptpolgrp_coppIfPol         = string
    #lfaccptpolgrp_spanVDestGrp      = string
    #lfaccptpolgrp_dwdmIfPol         = string
    #lfaccptpolgrp_qosPfcIfPol       = string
    #lfaccptpolgrp_qosSdIfPol        = string
    #lfaccptpolgrp_monInfraPol       = string
    #lfaccptpolgrp_fcIfPol           = string
    #lfaccptpolgrp_qosDppPol         = string
    lfaccptpolgrp_cdpIfPol           = string
    #lfaccptpolgrp_l2IfPol           = string
    #lfaccptpolgrp_stpIfPol          = string
    #lfaccptpolgrp_qosDppPol         = string
    lfaccptpolgrp_infraAttEntityP    = string
    #lfaccptpolgrp_l2InstPol         = string
  }))
}

# Interfaces | Leaf Switches | Policy Groups | PC Interfaces/VPC Interfaces
variable "lfpcif_map" {
  type = map(object( {
    lfpcif_description      = string
    lfpcif_lagtype          = string
    lfpcif_pcpol            = string
    lfpcif_fabricHIfPol     = string
    lfpcif_cdpIfPol         = string
    lfpcif_lldpIfPol        = string
    lfpcif_infraAttEntityP  = string
  }))
}

# Interfaces | Leaf Switches | Policy Groups | Leaf Breakout Port Groups
variable "lfbrkoutprtgrp_map" {
  type = map(object( {
    lfbrkoutprtgrp_description  = string
    lfbrkoutprtgrp_brkoutmap    = string
  }))
}

# Policies | Switch | Virtual Port Channel Default
variable "vpcdefault_map" {
  type = map(object( {
    vpcdef_switch1      = string
    vpcdef_switch2      = string
    vpcdef_domainpolicy = string
    vpcdef_groupID      = string
  }))
}

# Policies | Interface | Link Level
variable "linklevel_map" {
  type = map(object( {
    lnklvl_autoneg       = string
    lnklvl_description   = string
    lnklvl_fecmode       = string
    lnklvl_linkdebounce  = string
    lnklvl_name_alias    = string
    lnklvl_speed         = string
  }))
}

# # Policies | Interface | Link Level Flow Control
variable "linklevelflowcontrol_map" {
  type = map(object( {
    lnklvlfc_rcvadminstate   = string
    lnklvlfc_sendadminstate  = string
  }))
}

# # Policies | Interface | Priority Flow Control
variable "priorityflowcontrol_map" {
  type = map(object( {
    pfc_description  = string
    pfc_adminstate   = string
  }))
}

# Policies | Interface | link Flap
variable "linkflap_map" {
  type = map(object( {
    lnkflap_description = string
    lnkflap_maxerrors   = string
    lnkflap_maxflapsec  = string
  }))
}

# Policies | Interface | CDP Interface
variable "cdp_map" {
  type = map(object( {
    cdp_name_alias   = string
    cdp_description  = string
    cdp_admin_st     = string
  }))
}

# Policies | Interface | LLDP Interface
variable "lldp_map" {
  type = map(object( {
    lldp_name_alias   = string
    lldp_description  = string
    lldp_admin_rx_st  = string
    lldp_admin_tx_st  = string
  }))
}

# Policies | Interface | NetFlow

# Policies | Interface | Port Channel
variable "portchannel_map" {
  type = map(object( {
    portchannel_description = string
    portchannel_name_alias  = string
    portchannel_mode        = string
    portchannel_control     = string
    portchannel_minlinks    = string
    portchannel_maxlinks    = string
  }))
}

# Policies | Interface | Port Channel Member
variable "portchannelmember_map" {
  type = map(object( {
    portchannelmbr_description = string
    portchannelmbr_name_alias  = string
    portchannelmbr_priority    = string
    portchannelmbr_txrate      = string
  }))
}

# Policies | Interface | Spanning Tree Interface
variable "stpif_map" {
  type = map(object( {
    stpif_description = string
    stpif_name_alias  = string
    stpif_ctrl        = string
  }))
}

# Policies | Interface | Storm Control
# Policies | Interface | Data Plane Policing
# Policies | Interface | MCP Interface
# Policies | Interface | CoPP Interface
# Policies | Interface | L2 Interface
# Policies | Interface | Port Security
# Policies | Interface | MACsec
# Policies | Interface | Firewall
# Policies | Interface | DWDM
# Policies | Interface | 802.1x Port Authentication
# Policies | Interface | Slow Drain

# Policies | Global | Attachable Access Entity Profiles
variable "aaep_map" {
  type = map(object( {
    aaep_name           = string
    aaep_name_alias     = string
    aaep_description    = string
    enable_infra        = bool
    #aaep_RsAccessDomain = list  # MUST be String List (how do I do that??)
  }))
}

# variable "aaep_to_l2dom_map" {
#   type = map(object( {
#     aaep_key           = string
#     l2dom_key          = string
#   }))
# }

variable "aaep_to_physdom_map" {
  type = map(object( {
    aaep_key           = string
    physdom_key        = string
  }))
}

# variable "aaep_to_vmmdom_map" {
#   type = map(object( {
#     type               = string
#     aaep_key           = string
#     vmmdom_key         = string
#   }))
# }

variable "aaep_to_l3dom_map" {
  type = map(object( {
    aaep_key           = string
    l3dom_key          = string
  }))
}

# Policies | Global | QOS Class
# Policies | Global | PTP User Profile
# Policies | Global | DHCP Relay
# Policies | Global | MCP Instance Policy Default
# Policies | Global | Error Disabled Recovery Policy
# Policies | Troubleshooting | SPAN | SPAN Src Groups
# Policies | Troubleshooting | SPAN | SPAN Filter Groups
# Policies | Troubleshooting | SPAN | SNAP Dest Groups
# Policies | Troubleshooting | VSPAN | VSPAN Sessions

# Policies | Pools | VLAN
# range resource isn't a complete resource block --missing a key field therefore using the rest resource
variable "vlanpools_map" {
  type = map(object( {
    #vlanpool_name_alias      = string
    vlanpool_description      = string
    vlanpool_name             = string
    vlanpool_alloc_mode       = string
    }))
}

variable "vlanranges_map" {
  type = map(object( {
    vlanpool_assc             = string
    vlanrange_description     = string
    vlanrange_start_range     = string
    vlanrange_end_range       = string
    vlanrange_alloc_mode      = string
    vlanrange_role            = string
    }))
}

# variable "vlanpoolrange_map" {
#   type = map(object( {
#     vlanpoolrange_description = string
#     vlanpoolrange_from        = number
#     vlanpoolrange_to          = number
#     vlanpoolrange_allocmode   = string
#     }))
# }

# Policies | Physical and External Domains | Pysical Domains
variable "physdom_map" {
  type = map(object( {
    physdom_key                  = string
    physdom_name_alias           = string
    vlanpool_assc                = string
    #phydom_rsinfra_vlan         = string
    #phydom_rsinfra_vlan_def     = string
    #phydom_rsinfra_vip_addr     = string
    #phydom_rsinfra_extnw        = string
    #phydom_rsinfra_vxlan_def    = string
    }))
}

# Policies | Physical and External Domains | L3 Domains
variable "l3dom_map" {
  type = map(object( {
    l3dom_key                    = string
    l3dom_name_alias             = string
    vlanpool_assc                = string
    #l3dom_rsinfra_vlan          = string
    #l3dom_rsinfra_vlan_def      = string
    #l3dom_rsinfra_vip_addr      = string
    #l3dom_rsinfra_extnw         = string
    #l3dom_rsinfra_vxlan_def     = string
    }))
}