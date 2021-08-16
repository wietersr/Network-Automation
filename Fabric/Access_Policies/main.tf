
#########################################################################
# Fabric Access Policies for ACI Deployment via Terraform
#########################################################################

# NOTES:
# 1)  "Error: invalid character '<' looking for beginning of value" is likely due to a statefile that has changed
#     (examples: change a filename of a tf file will cause a state mismatch) 
#     Many times, this error comes after making many changes where state isn't fully resolved upon the first apply. One
#     may simply run an apply multiple times and the state mistmatches will resolve.
#     Can re path the statefile if necessary in backend.tf to resolve if the above does not fix the error.
# 2)  I don't generally code for default policies. Rather, I concentrate on custom policies until the code is matured.

# Sub-module definitions for Fabric Access Policies 
# -------------------------------------------------
# Switches | Leaf Switches | [Leaf/node] Profiles (Single Switch Profiles)
# NOTE: Single switch (leaf/node) profiles exist, where each builds a single switch (leaf/node) selector
resource "aci_leaf_profile" "snodeprofileLocalName" { # infraHPathS
  for_each = var.snodeprofile_map
    name                        = each.key
    annotation                  = "orchestrator:terraform"
    name_alias                  = each.value.snodeprof_name_alias
    leaf_selector { # infraHLeafS
        name                    = each.value.snodeprof_selectorname
        switch_association_type = each.value.snodeprof_switchassc_type
        node_block { #infraNodeBlk
            name                = each.value.snodeprof_blockname
            from_               = each.value.snodeprof_from_node
            to_                 = each.value.snodeprof_to_node
        }
    }
    relation_infra_rs_acc_port_p = [for lfifprof in each.value.snodeprof_lfifprof_key : "uni/infra/accportprof-${lfifprof}"]
}

# Switches | Leaf Switches | [Leaf/node] Profiles (Dual Switch Profiles)
# NOTE: Dual switch (leaf/node) profiles exist, where each builds a PAIR of single switch (leaf/node) selectors
resource "aci_leaf_profile" "dnodeprofileLocalName" { # infraHPathS
  for_each = var.dnodeprofile_map
    name                        = each.key
    annotation                  = "orchestrator:terraform"
    name_alias                  = each.value.dnodeprof_name_alias
    dynamic "leaf_selector" { # infraHLeafS
        for_each = each.value.dnodeprof_leafselector
        content {
            name                    = leaf_selector.key
            switch_association_type = leaf_selector.value.dnodeprof_switchassc_type
            node_block { #infraNodeBlk
                name                = leaf_selector.value.dnodeprof_blockname
                from_               = leaf_selector.value.dnodeprof_from_node
                to_                 = leaf_selector.value.dnodeprof_to_node
            }
        }
    }
    relation_infra_rs_acc_port_p = [for lfifprof in each.value.dnodeprof_lfifprof_key : "uni/infra/accportprof-${lfifprof}"]
    # don't build the "dual" profiles until the single profiles are built to avoid errors
    depends_on = [ aci_leaf_profile.snodeprofileLocalName ]
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles
resource "aci_leaf_interface_profile" "lfifprofileLocalName" { #infra:AccPortP
    for_each = var.lfprofile_map
      name         = each.key
      name_alias   = each.value.lfprofile_name_alias
      description  = each.value.lfprofile_description
      annotation = "orchestrator:terraform"
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors
resource "aci_access_port_selector" "accprtselLocalName" { #infra:HPortS
    for_each = var.accportsel_map
      leaf_interface_profile_dn = "uni/infra/accportprof-${each.value.lfprofile_key}"
      name = each.key
      name_alias = each.value.lfsel_name_alias
      description = each.value.ifsel_description
      annotation = "orchestrator:terraform"
      access_port_selector_type = each.value.ifsel_type
      #relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.lfaccptpolgrpLocalName[each.value.ifsel_accprtpolgrp].id
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups
resource "aci_access_port_block" "accportblkLocalName" { #infra:PortBlk
  for_each = var.accportblk_map
    access_port_selector_dn = aci_access_port_selector.accprtselLocalName[each.value.lfselector_key].id
    name = each.value.portblk_name
    name_alias = each.key
    description = each.value.portblk_description
    annotation = "orchestrator:terraform"
    from_card = each.value.portblk_fromcard
    from_port = each.value.portblk_fromport
    to_card = each.value.portblk_tocard
    to_port = each.value.portblk_toport
    #relation_infra_rs_acc_bndl_subgrp = "" #override policy group assc.
}

#The access group assigns access/pc/vpc port policy group to the interface selector
resource "aci_access_group" "accgrpLocalName" { #infra:rsaccbasegrp
  for_each = var.accessgrp_map
    access_port_selector_dn = aci_access_port_selector.accprtselLocalName[each.value.accgrp_lfselector_key].id
    annotation = "orchestrator:terraform"
    fex_id = "101" #static unless otherwise necessary: each.value.accgrp_fexid
    tdn = "uni/infra/funcprof/${each.value.accgrp_type}-${each.value.accgrp_policygrp_key}"
}

#######
# Interfaces | Leaf Interfaces | Profiles | FEX Profiles
resource "aci_fex_profile" "lffexprofileLocalName" { #infra:FexP
    for_each = var.lffexprofile_map
      name         = each.key
      name_alias   = each.value.lffexprofile_name_alias
      description  = each.value.lffexprofile_description
      annotation = "orchestrator:terraform"
}

# Interfaces | Leaf Interfaces | Profiles | Leaf FEX Profiles | Leaf FEX Policy Groups
resource "aci_fex_bundle_group" "lffexpolgrpLocalName" { #infra:FexP
    for_each = var.lffexpolgrp_map
      name         = each.key
      name_alias   = each.value.fexpolgrp__name_alias
      description  = each.value.fexpolgrp__description
      fex_profile_dn = aci_fex_profile.lffexprofileLocalName[each.value.fexpolgrp_key].id
      annotation = "orchestrator:terraform"
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors for FEX
resource "aci_access_port_selector" "fexaccprtselLocalName" { #infra:HPortS
    for_each = var.fexaccportsel_map
      leaf_interface_profile_dn = "uni/infra/accportprof-${each.value.fexprofile_key}"
      name = each.key
      description = each.value.fexifsel_description
      annotation = "orchestrator:terraform"
      access_port_selector_type = each.value.fexifsel_type
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups for fex
resource "aci_access_port_block" "fexaccportblkLocalName" { #infra:PortBlk
  for_each = var.fexaccportblk_map
    access_port_selector_dn = aci_access_port_selector.fexaccprtselLocalName[each.value.fexlfselector_key].id
    name = each.value.fexportblk_name
    name_alias = each.key
    description = each.value.fexportblk_description
    annotation = "orchestrator:terraform"
    from_card = each.value.fexportblk_fromcard
    from_port = each.value.fexportblk_fromport
    to_card = each.value.fexportblk_tocard
    to_port = each.value.fexportblk_toport
    #relation_infra_rs_acc_bndl_subgrp = "" #override policy group assc.
}

#The access group assigns access/pc/vpc port policy group to the interface selector for fex
resource "aci_access_group" "fexaccgrpLocalName" { #infra:rsaccbasegrp
  for_each = var.fexaccessgrp_map
    access_port_selector_dn = aci_access_port_selector.fexaccprtselLocalName[each.value.fexaccgrp_lfselector_key].id
    annotation = "orchestrator:terraform"
    fex_id = each.value.fexaccgrp_fexID
    tdn = "uni/infra/funcprof/accbundle-${each.value.fexaccgrp_policygrp_key}"
}

/*
This code got too complicated, so went traditional route to build the leaf profile code using 
multiple resource blocks--may refactor at a later date to refine that into something more
efficient. leaving this parked here for later use and reference.

# Create local variables to contruct the ifselector name/associate it to the profile dn, and
# assign node ranges.
locals {
    leaf_profile_map_resolved_lfselectors = {
        for key, value in var.lf_selectors_map:
            key => {
                lfsel_name = value.lfsel_name
                lfsel_profile_list_dn = [
                    for lfifprofileLocalName in value.lfsel_profile_list:
                    aci_leaf_interface_profile.lfifprofileLocalName[lfifprofileLocalName].id
                ]
                node_from = value.lfsel_fromport
                node_to = value.lfsel_toport
                ifpolgrp = value.ifpolgrp_assc 
            }
    }
}
# Pull in local vars to construct the leaf port selector
resource "aci_leaf_profile" "lfprofileLocalName" { 
    for_each = local.leaf_profile_map_resolved_lfselectors
        name        = each.value.lfsel_name
        relation_infra_rs_acc_port_p = each.value.lfsel_profile_list_dn
        leaf_selector { # infra:HPortS
            name = each.value.lfsel_name
            switch_association_type = "range"
            node_block { #infra:PortBlk
                name = "blk1"
                from_ = each.value.node_from
                to_   = each.value.node_to
        }
    }
}
*/

# Interfaces | Leaf Interfaces | Overrides
# All our overides at 6/17/2021 are Path Type: Port (Direct Port Channel & Virtual Port Channel also options, but not configurable)
resource "aci_rest" "lfoveridesLocalName" { # infraHPathS
  path = "/api/node/mo/uni/infra/hpaths-${each.key}.json"
  for_each = var.lfoverides_map
  #depends_on = [ resource.resourceLocalName ]  # Will likely need to add a dependancy module to ensure nodes/paths exist?? --placeholder
    payload = <<-EOF
    {
        "infraHPathS": {
            "attributes": {
                "dn": "uni/infra/hpaths-${each.key}",
                "annotation": "orchestrator:terraform",
                "name": "${each.key}",
                "descr": "${each.value.lfoverides_description}",
                "rn": "hpaths-${each.key}"
            },
            "children": [
                {
                    "infraRsHPathAtt": {
                        "attributes": {
                            "tDn": "topology/pod-${each.value.lfoverides_podID}/paths-${each.value.lfoverides_nodeID}/pathep-[${each.value.lfoverides_portID}]"
                        },
                        "children": []
                    }
                },
                {
                    "infraRsPathToAccBaseGrp": {
                        "attributes": {
                            "tDn": "${aci_leaf_access_port_policy_group.lfaccptpolgrpLocalName[each.value.lfoverides_portpolicygrp].id}"
                        },
                        "children": []
                    }
                }
            ]
        }
    }
    EOF
}

# Interfaces | Leaf Interfaces | Policy Groups | Leaf Access Ports
resource "aci_leaf_access_port_policy_group" "lfaccptpolgrpLocalName" { # infra:AccPortGrp
  for_each = var.lfaccptpolgrp_map
    name                              = each.key
    annotation                        = "orchestrator:terraform"
    name_alias                        = each.value.lfaccptpolgrp_name_alias
    description                       = each.value.lfaccptpolgrp_description
    ###############################################################################################################
    ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
    ###############################################################################################################
    #relation_infra_rs_span_v_src_grp         = each.value.lfaccptpolgrp_spanVSrcGrp
    #relation_infra_rs_stormctrl_if_pol       = each.value.lfaccptpolgrp_stormctrlIfPol
    #relation_infra_rs_poe_if_pol             = each.value.lfaccptpolgrp_poeIfPol
    relation_infra_rs_lldp_if_pol             = aci_lldp_interface_policy.lldpLocalName[each.value.lfaccptpolgrp_lldpIfPol].id
    #relation_infra_rs_macsec_if_pol          = each.value.lfaccptpolgrp_macsecIfPol
    #relation_infra_rs_qos_dpp_if_pol         = each.value.lfaccptpolgrp_qosDppPol
    relation_infra_rs_h_if_pol                = aci_rest.linklevelLocalName[each.value.lfaccptpolgrp_fabricHIfPol].id
    #relation_infra_rs_netflow_monitor_pol    = each.value.lfaccptpolgrp_netflowMonitorPol
    #relation_infra_rs_l2_port_auth_pol       = each.value.lfaccptpolgrp_l2PortAuthPol
    #relation_infra_rs_mcp_if_pol             = each.value.lfaccptpolgrp_mcpIfPol
    #relation_infra_rs_l2_port_security_pol   = each.value.lfaccptpolgrp_l2PortSecurityPol
    #relation_infra_rs_copp_if_pol            = each.value.lfaccptpolgrp_coppIfPol
    #relation_infra_rs_span_v_dest_grp        = each.value.lfaccptpolgrp_spanVDestGrp
    #relation_infra_rs_dwdm_if_pol            = each.value.lfaccptpolgrp_dwdmIfPol
    #relation_infra_rs_qos_pfc_if_pol         = each.value.lfaccptpolgrp_qosPfcIfPol
    #relation_infra_rs_qos_sd_if_pol          = each.value.lfaccptpolgrp_qosSdIfPol
    #relation_infra_rs_mon_if_infra_pol       = each.value.lfaccptpolgrp_monInfraPol
    #relation_infra_rs_fc_if_pol              = each.value.lfaccptpolgrp_fcIfPol
    #relation_infra_rs_qos_ingress_dpp_if_pol = each.value.lfaccptpolgrp_qosDppPol
    relation_infra_rs_cdp_if_pol              = aci_cdp_interface_policy.cdpLocalName[each.value.lfaccptpolgrp_cdpIfPol].id
    #relation_infra_rs_l2_if_pol              = each.value.lfaccptpolgrp_l2IfPol
    #relation_infra_rs_stp_if_pol             = each.value.lfaccptpolgrp_stpIfPol
    #relation_infra_rs_qos_egress_dpp_if_pol  = each.value.lfaccptpolgrp_qosDppPol
    relation_infra_rs_att_ent_p               = aci_attachable_access_entity_profile.aaepLocalName[each.value.lfaccptpolgrp_infraAttEntityP].id
    #relation_infra_rs_l2_inst_pol            = each.value.lfaccptpolgrp_l2InstPol
}

# Interfaces | Leaf Switches | Policy Groups | PC Interfaces/VPC Interfaces
# Note: lagT attribute (value=link or node) distinguishes between PortChannel or Virtual PortChannel, respectively.
resource "aci_rest" "lfpcinterfaceLocalName" { # infraAccBndlGrp
  path = "/api/node/mo/uni/infra/funcprof/accbundle-${each.key}.json"
  for_each = var.lfpcif_map
    payload = <<-EOF
    {
        "infraAccBndlGrp": {
            "attributes": {
                "dn": "uni/infra/funcprof/accbundle-${each.key}",
                "annotation": "orchestrator:terraform",
                "name": "${each.key}",
                "lagT": "${each.value.lfpcif_lagtype}",
                "descr": "${each.value.lfpcif_description}",
                "rn": "accbundle-${each.key}"
            },
            "children": [
                {
                    "infraRsLacpPol":{
                      "attributes":{
                          "tnLacpLagPolName":"${each.value.lfpcif_pcpol}"
                      },
                      "children":[]
                    }
                },
                {
                    "infraRsHIfPol": {
                        "attributes": {
                            "tnFabricHIfPolName": "${each.value.lfpcif_fabricHIfPol}"
                        },
                        "children": []
                    }
                },
                {
                    "infraRsCdpIfPol": {
                        "attributes": {
                            "tnCdpIfPolName": "${each.value.lfpcif_cdpIfPol}"
                        },
                        "children": []
                    }
                },
                {
                    "infraRsLldpIfPol": {
                        "attributes": {
                            "tnLldpIfPolName": "${each.value.lfpcif_lldpIfPol}"
                        },
                        "children": []
                    }
                },
                {
                    "infraRsAttEntP": {
                        "attributes": {
                            "tDn": "${aci_attachable_access_entity_profile.aaepLocalName[each.value.lfpcif_infraAttEntityP].id}"
                         },
                        "children": []
                    }
                }
            ]
        }
    }
    EOF
}

# Interfaces | Leaf Switches | Policy Groups | Leaf Breakout Port Groups
resource "aci_rest" "lfbrkoutprtgrpLocalName" { # infraBrkoutPortGrp
  path = "/api/node/mo/uni/infra/funcprof/brkoutportgrp-${each.key}.json"
  for_each = var.lfbrkoutprtgrp_map
    payload = <<-EOF
    {
          "infraBrkoutPortGrp": {
              "attributes": {
                  "dn": "uni/infra/funcprof/brkoutportgrp-${each.key}",
                  "annotation": "orchestrator:terraform",
                  "name": "${each.key}",
                  "descr": "${each.value.lfbrkoutprtgrp_description}",
                  "brkoutMap": "${each.value.lfbrkoutprtgrp_brkoutmap}",
                  "rn": "brkoutportgrp-${each.key}"
              },
              "children": []
          }
      }
    EOF
}

# Policies | Switch | Virtual Port Channel Default
resource "aci_vpc_explicit_protection_group" "vpcdefaultLocalName" { # fabric:ProtPol
  for_each = var.vpcdefault_map
    name                              = each.key
    annotation                        = "orchestrator:terraform"
    switch1                           = each.value.vpcdef_switch1
    switch2                           = each.value.vpcdef_switch2
    vpc_domain_policy                 = each.value.vpcdef_domainpolicy
    vpc_explicit_protection_group_id  = each.value.vpcdef_groupID
}

# Policies | Interface | Link Level
# There are two ways to "paint" a rest resource block: condensed (this: link level) and 
# long-form (see link level flow control). While condensed is easier to read, long-form
# is preferred because one can capture an example config's payload from the [ACI] 
# API inspector and use that payload as-is with the addition of interpolated variables.
# When using rest resource blocks, inlcude the "annotation" attribute key with value: 
# "orchestrator:terraform" to ensure terraform-provisioned objects acquire the blue icon
# shown in the GUI -- this distinguishes object installed mannually vs. automation. 
# the Terraform ACI provider auto-includes the annotation attribute by default.
resource "aci_rest" "linklevelLocalName" { # fabric:HIfPol
  for_each = var.linklevel_map
    path = "/api/mo/uni/infra/hintfpol-${each.key}.json"
    class_name = "fabricHIfPol"
    content = {
      "annotation"   = "orchestrator:terraform"
      "autoNeg"      = each.value.lnklvl_autoneg
      "descr"        = each.value.lnklvl_description
      "fecMode"      = each.value.lnklvl_fecmode
      "linkDebounce" = each.value.lnklvl_linkdebounce
      "name"         = each.key
      "nameAlias"    = each.value.lnklvl_name_alias
      "speed"        = each.value.lnklvl_speed
    }
}

# # Policies | Interface | Link Level Flow Control
resource "aci_rest" "linklevelflowcontrolLocalName" { # qosLlfcIfPol
  path = "/api/mo/uni/infra/llfc-${each.key}.json"
  for_each = var.linklevelflowcontrol_map
    payload = <<-EOF
    {
            "qosLlfcIfPol": {
                "attributes": {
                    "dn": "uni/infra/llfc-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "llfcRcvAdminSt": "${each.value.lnklvlfc_rcvadminstate}",
                    "llfcSendAdminSt": "${each.value.lnklvlfc_sendadminstate}",
                    "rn": "llfc-${each.key}"                    
                },
                "children": []
            }
    }
    EOF
}

# # Policies | Interface | Priority Flow Control
resource "aci_rest" "priorityflowcontrolLocalName" { # qos:PfcIfPol
  path = "/api/mo/uni/infra/pfc-${each.key}.json"
  for_each = var.priorityflowcontrol_map
    payload = <<-EOF
    {
            "qosPfcIfPol": {
                "attributes": {
                    "dn": "uni/infra/pfc-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "descr": "${each.value.pfc_description}",
                    "adminSt": "${each.value.pfc_adminstate}"
                }
            }
    }
    EOF
}

# # Policies | Interface | Link Flap
resource "aci_rest" "linkflapLocalName" { # fabric:LinkFlapPol
  path = "/api/mo/uni/infra/linkflappol-${each.key}.json"
  for_each = var.linkflap_map
    payload = <<-EOF
    {
            "fabricLinkFlapPol": {
                "attributes": {
                    "dn": "uni/infra/linkflappol-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "descr": "${each.value.lnkflap_description}",
                    "linkFlapErrorMax":  "${each.value.lnkflap_maxerrors}",
                    "linkFlapErrorSeconds": "${each.value.lnkflap_maxflapsec}"
                }
            }
    }
    EOF
}

# Policies | Interface | CDP Interface
resource "aci_cdp_interface_policy" "cdpLocalName" { # cdp:IfPol
  for_each        = var.cdp_map
    name          = each.key
    annotation    = "orchestrator:terraform"
    name_alias    = each.value.cdp_name_alias
    description   = each.value.cdp_description
    admin_st      = each.value.cdp_admin_st
}

# Policies | Interface | LLDP Interface
resource "aci_lldp_interface_policy" "lldpLocalName" { # lldp:IfPol
  for_each        = var.lldp_map
    name          = each.key
    annotation    = "orchestrator:terraform"
    name_alias    = each.value.lldp_name_alias
    description   = each.value.lldp_description
    admin_rx_st   = each.value.lldp_admin_rx_st
    admin_tx_st   = each.value.lldp_admin_tx_st
    #tenant_dn          = aci_tenant.tenantLocalName.id
    #relation_fv_rs_ctx = aci_vrf.vrfLocalName[each.value.vrf].id
}

# Policies | Interface | NetFlow
# Policies | Interface | Port Channel
resource "aci_rest" "portchannelLocalName" { # lacp:LagPol
  path = "/api/mo/uni/infra/lacplagp-${each.key}.json"
  for_each = var.portchannel_map
    payload = <<-EOT
    {
            "lacpLagPol": {
                "attributes": {
                    "dn": "uni/infra/lacplagp-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "descr": "${each.value.portchannel_description}",
                    "nameAlias": "${each.value.portchannel_name_alias}",
                    "mode": "${each.value.portchannel_mode}",
                    "ctrl": "${each.value.portchannel_control}",
                    "minLinks":  "${each.value.portchannel_minlinks}",
                    "maxLinks":  "${each.value.portchannel_maxlinks}",
                }
            }
    }
    EOT
}

# Policies | Interface | Port Channel Member
resource "aci_rest" "portchannelmemberLocalName" { # lacp:IfPol
  path = "/api/mo/uni/infra/lacpifp-${each.key}.json"
  for_each = var.portchannelmember_map
    payload = <<-EOT
    {
            "lacpIfPol": {
                "attributes": {
                    "dn": "uni/infra/lacpifp-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "descr": "${each.value.portchannelmbr_description}",
                    "nameAlias": "${each.value.portchannelmbr_name_alias}",
                    "prio": "${each.value.portchannelmbr_priority}",
                    "txRate":  "${each.value.portchannelmbr_txrate}",
                }
            }
    }
    EOT
}

# Policies | Interface | Spanning Tree Interface
resource "aci_rest" "stpifLocalName" { # stp:IfPol
  path = "/api/mo/uni/infra/ifPol-${each.key}.json"
  for_each = var.stpif_map
    payload = <<-EOT
    {
            "stpIfPol": {
                "attributes": {
                    "dn": "uni/infra/ifPol-${each.key}",
                    "annotation": "orchestrator:terraform",
                    "name": "${each.key}",
                    "descr": "${each.value.stpif_description}",
                    "nameAlias": "${each.value.stpif_name_alias}",
                    "ctrl": "${each.value.stpif_ctrl}",
                }
            }
    }
    EOT
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

#########################################################################################################
# Policies | Global | Attachable Access Entity Profiles
# resource "aci_attachable_access_entity_profile" "aaepLocalName" { # infra:AttEntityP
#   for_each = var.aaep_map
#     name                     = each.key
#     name_alias               = each.value.aaep_name_alias
#     description              = each.value.aaep_description
    #relation_infra_rs_dom_p  = each.value.aaep_RsAccessDomain # MUST be String List (how do I do that??)
#}

### Example Code for advanced processing of AAEP resources ###

# The AAEP is technically one of the most complex resources to process due to the many relationships it 
# has with other class resources. 

# We need to resolve domain IDs and build a list to associate to AAEPs using keys, which takes a map and returns a list
# containing the keys from that map.The keys are returned in lexicographical order, ensuring that the result will
# be identical as long as the keys in the map don't change.
locals {
    # aaep_to_l2dom_map_resolved_domain = {  #future code placeholder for L2Domains
    #     for key, value in var.aaep_to_l2dom_map:
    #     key => {
    #         l2dom_id = module.l2dom[value.l2dom_key].l2dom_id
    #         aaep_key = value.aaep_key
    #     }
    # }
    aaep_to_physdom_map_resolved_domain = {
        for key, value in var.aaep_to_physdom_map:
        key => {
            physdom_id = aci_physical_domain.physdomLocalName[value.physdom_key].id
            aaep_key = value.aaep_key
        }
    }
    # aaep_to_vmmdom_map_resolved_domain = { #future code placeholder for VMM Domains
    #     for key, value in var.aaep_to_vmmdom_map:
    #     key => {
    #         vmmdom_id = value.type=="dvs" ? module.vmm_domains_dvs[value.vmmdom_key].id : module.vmm_domains_ave[value.vmmdom_key].id
    #         aaep_key = value.aaep_key
    #     }
    # }
    aaep_to_l3dom_map_resolved_domain = {
        for key, value in var.aaep_to_l3dom_map:
        key => {
            l3dom_id = aci_l3_domain_profile.l3domprofileLocalName[value.l3dom_key].id
            aaep_key = value.aaep_key
        }
    }
    aaep_map_with_domains = {
        for key, value in var.aaep_map:
        key => {
            aaep_name = value.aaep_name
            relation_infra_rs_dom_p = concat(
            # [
            #     for key2, value2 in local.aaep_to_l2dom_map_resolved_domain:
            #     value2.l2dom_id
            #     if value2.aaep_key == key
            # ],
            [
                for key3, value3 in local.aaep_to_physdom_map_resolved_domain:
                value3.physdom_id
                if value3.aaep_key == key
            ],
            [
                for key4, value4 in local.aaep_to_l3dom_map_resolved_domain:
                value4.l3dom_id
                if value4.aaep_key == key
            ]
            # [
            #     for key5, value5 in local.aaep_to_vmmdom_map_resolved_domain:
            #     value5.vmmdom_id
            #     if value5.aaep_key == key
            # ]
            )
        }
    }
}

resource "aci_attachable_access_entity_profile" "aaepLocalName" {
    for_each = local.aaep_map_with_domains
    depends_on = [
        #l2dom,
        aci_physical_domain.physdomLocalName,
        aci_l3_domain_profile.l3domprofileLocalName,
        #vmm_domains_ave,
        #vmm_domains_dvs
    ]
    name                    = each.value.aaep_name
    annotation              = "orchestrator:terraform"
    relation_infra_rs_dom_p = each.value.relation_infra_rs_dom_p #Relationship is formed from 
}
####

# Enable infra access on AAEP
resource "aci_vlan_encapsulationfor_vxlan_traffic" "infra" {
    for_each = { for key, value in var.aaep_map:
                key => value
                if value.enable_infra == true
    }
    depends_on = [ aci_attachable_access_entity_profile.aaepLocalName ]
    attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.aaepLocalName[each.key].id
}

#########################################################################################################
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
resource "aci_vlan_pool" "vlanpoolsLocalName" { # fvns:VlanInstP
  for_each = var.vlanpools_map
    name                     = each.value.vlanpool_name
    annotation               = "orchestrator:terraform"
    description              = each.value.vlanpool_description
    alloc_mode               = each.value.vlanpool_alloc_mode
}

resource "aci_ranges" "vlanrangesLocalName" { # fvns:EncapBlk
  for_each = var.vlanranges_map
    annotation      = "orchestrator:terraform"
    description     = each.value.vlanrange_description
    vlan_pool_dn    = aci_vlan_pool.vlanpoolsLocalName[each.value.vlanpool_assc].id
    from            = each.value.vlanrange_start_range
    to              = each.value.vlanrange_end_range
    alloc_mode      = each.value.vlanrange_alloc_mode
    role            = each.value.vlanrange_role
}

# Policies | Physical and External Domains | Physical Domains
resource "aci_physical_domain" "physdomLocalName" { # phys:DomP
  for_each = var.physdom_map
  name                                = each.value.physdom_key
  annotation                          = "orchestrator:terraform"
  name_alias                          = each.value.physdom_name_alias
  relation_infra_rs_vlan_ns           = aci_vlan_pool.vlanpoolsLocalName[each.value.vlanpool_assc].id
  #relation_infra_rs_vlan_ns_def      = each.value.physdom_rsinfra_vlan_def
  #relation_infra_rs_vip_addr_ns      = each.value.physdom_rsinfra_vip_addr
  #relation_extnw_rs_out              = each.value.physdom_rsinfra_extnw
  #relation_infra_rs_dom_vxlan_ns_def = each.value.physdom_rsinfra_vxlan_def
}

#Policies | Physical and External Domains | L3 Domains
resource "aci_l3_domain_profile" "l3domprofileLocalName" { # l3ext:DomP
  for_each = var.l3dom_map
  name                                = each.value.l3dom_key
  annotation                          = "orchestrator:terraform"
  name_alias                          = each.value.l3dom_name_alias
  relation_infra_rs_vlan_ns           = aci_vlan_pool.vlanpoolsLocalName[each.value.vlanpool_assc].id
  #relation_infra_rs_vlan_ns_def      = each.value.l3dom_rsinfra_vlan_def
  #relation_infra_rs_vip_addr_ns      = each.value.l3dom_rsinfra_vip_addr
  #relation_extnw_rs_out              = each.value.l3dom_rsinfra_extnw
  #relation_infra_rs_dom_vxlan_ns_def = each.value.l3dom_rsinfra_vxlan_def
}