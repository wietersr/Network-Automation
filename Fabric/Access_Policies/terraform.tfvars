/*
    author: Rob Wieters

    usage:
 
      To set lots of variables, it is more convenient to specify their values in a variable definitions 
      file (with a filename ending in either .tfvars or .tfvars.json). If a use case presents itself,
      one could also specify a tfvars file on the command line with -var-file: terraform apply -var-file="testing.tfvars"

      Note: This is how Terraform Cloud passes workspace variables to Terraform.

      A variable definitions file uses the same basic syntax as Terraform language files, but consists 
      only of variable name assignments:

      ANSI Text Headers are generated using https://manytools.org/hacker-tools/ascii-banner/ with font: ANSI Shadow and normal spacing
      and are used to visually separate the major sections, which aid in quickly navigating between them.

    references:
      - https://www.terraform.io/docs/language/values/variables.html#variable-definitions-tfvars-files

*/

# List of objects "to_set" example
# ylw_vrf_set = [
#     "NonProd-VRF",
#     "BTS_Prod-VRF",
#     "SCS_Prod-VRF",
#     "EBZ_Prod-VRF",
#     "ADCS_Prod-VRF",
#     "ADCE_Prod-VRF",
#     "ADCE_PCI_Prod-VRF"
# ]

# Map of objects: example
# bd_map = {
#     "BTS_NonProd_Database_Svc" = {
#         subnet = "192.168.0.1/24"
#         vrf    = "NonProd-VRF"
#         }
#     "BTS_NonProd_FnP_Svc" = {
#         subnet = "192.168.1.1/24"
#         vrf    = "NonProd-VRF"
#         }
#     }

# Sub-module definitions for Fabric Access Policies 
# -------------------------------------------------

#    ███████╗██╗    ██╗██╗████████╗ ██████╗██╗  ██╗    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██╔════╝██║    ██║██║╚══██╔══╝██╔════╝██║  ██║    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    ███████╗██║ █╗ ██║██║   ██║   ██║     ███████║    ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
#    ╚════██║██║███╗██║██║   ██║   ██║     ██╔══██║    ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
#    ███████║╚███╔███╔╝██║   ██║   ╚██████╗██║  ██║    ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
#    ╚══════╝ ╚══╝╚══╝ ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝


# Switches | Leaf Switches | [Leaf/node] Profiles (Single Switch Profiles)
snodeprofile_map = {
    "BLF123U201-SWP-tftest" = {                                 # (required) key = name 1-64chars
        snodeprof_name_alias       = ""                         # (optional) name alias
        snodeprof_description      = ""                         # (optional) Description 0-128chars
        snodeprof_selectorname     = "BLF123U201-tftest"        # (required) node selector name
        snodeprof_lfifprof_key    = ["BLF123U201-LIP-tftest"]   # (required) leaf interface profile assc.
        snodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
        snodeprof_blockname       = "bede6bee63ee0d62"          # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
        snodeprof_from_node       = 201                         # (required) from_nodeID
        snodeprof_to_node         = 201                         # (required) to_nodeID
    }
    "BLF124U202-SWP-tftest" = {                                 # (required) key = name 1-64chars
        snodeprof_name_alias       = ""                         # (optional) name alias
        snodeprof_description      = ""                         # (optional) Description 0-128chars
        snodeprof_selectorname     = "BLF124U202-tftest"        # (required) node selector name
        snodeprof_lfifprof_key    = ["BLF124U202-LIP-tftest"]   # (required) interface selector profile assc.        
        snodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
        snodeprof_blockname       = "2ad8830fab1da6dd"          # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
        snodeprof_from_node       = 202                         # (required) from_nodeID
        snodeprof_to_node         = 202                         # (required) to_nodeID
    }
    /*
    # New "Single-Switch" Profile Template
    "-tftest" = {                                 # (required) key = name 1-64chars
        snodeprof_name_alias       = ""                         # (optional) name alias
        snodeprof_description      = ""                         # (optional) Description 0-128chars
        snodeprof_selectorname     = "-tftest"        # (required) node selector name
        snodeprof_lfifprof_key    = ["-tftest"]   # (required) interface selector profile assc.        
        snodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
        snodeprof_blockname       = ""          # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
        snodeprof_from_node       =                          # (required) from_nodeID
        snodeprof_to_node         =                          # (required) to_nodeID
    }
    */

}

# Switches | Leaf Switches | [Leaf] Profiles (Dual Switch Profiles)
# NOTE: adding leaf selectors in reverse numerical order will and them in numerical order in the APIC
dnodeprofile_map = {
    "BLF123U201_124U202-SWP-tftest" = {                                 # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["BLF123U201_124U202-LIP-tftest"]  # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "BLF123U201-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "1125af90323f52ce"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 201                           # (required) from_nodeID
                dnodeprof_to_node       = 201                           # (required) to_nodeID
            },
            "BLF123U202-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "1125af90323f52ce"
                dnodeprof_from_node     = 202                           # (required) from_nodeID
                dnodeprof_to_node       = 202                           # (required) to_nodeID
            },
        }
    }
    "LF110K211_110L212-SWP-tftest" = {                                  # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["LF110K211_110L212-LIP-tftest"]   # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "LF110K212-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "b95a9027d59ab155"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 212                           # (required) from_nodeID
                dnodeprof_to_node       = 212                           # (required) to_nodeID
            },
            "LF110l211-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "c4a44caaeee3b6ae"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 211                           # (required) from_nodeID
                dnodeprof_to_node       = 211                           # (required) to_nodeID
            },
        }
    }
    "LF110M213_110N214-SWP-tftest" = {                                  # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["LF110M213_110N214-LIP-tftest"]   # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "LF110N214-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "5558314f7f3f8c34"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 214                           # (required) from_nodeID
                dnodeprof_to_node       = 214                           # (required) to_nodeID
            },
            "LF110M213-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "fd441005e254bd9b"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 213                           # (required) from_nodeID
                dnodeprof_to_node       = 213                           # (required) to_nodeID
            },
        }
    }
    "LF134J219_134J220-SWP-tftest" = {                                  # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["LF134J219_134J220-LIP-tftest"]   # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "LF134J220-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "892318094d1a3713"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 220                           # (required) from_nodeID
                dnodeprof_to_node       = 220                           # (required) to_nodeID
            },
            "LF134J219-tftest" = {                                      # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "3dfd4d1ccf0d277b"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 219                           # (required) from_nodeID
                dnodeprof_to_node       = 219                           # (required) to_nodeID
            },
        }
    }
    "LF139J215_139K216-SWP-tftest" = {                                  # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["LF139J215_139K216-LIP-tftest"]   # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "L216-tftest" = {                                           # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "ef6b6a46235d6431"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 216                           # (required) from_nodeID
                dnodeprof_to_node       = 216                           # (required) to_nodeID
            },
            "L215-tftest" = {                                           # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = "61d5c301ef13e675"            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     = 215                           # (required) from_nodeID
                dnodeprof_to_node       = 215                           # (required) to_nodeID
            },
        }
    }
    /*
    # New "Dual-Switch" Profile Template
    "-tftest" = {                                 # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["-tftest"]  # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = ""            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     =                            # (required) from_nodeID
                dnodeprof_to_node       =                            # (required) to_nodeID
            },
            "-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = ""          # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     =                            # (required) from_nodeID
                dnodeprof_to_node       =                            # (required) to_nodeID
            },
        }
    }
    */
}

/*
    "-tftest" = {                                 # (required) key = name 1-64chars
        dnodeprof_name_alias       = ""                                 # (optional) name alias
        dnodeprof_description      = ""                                 # (optional) Description 0-128chars
        dnodeprof_lfifprof_key     = ["-tftest"]  # (required) interface selector profile assc.        
        dnodeprof_leafselector     = {
            "BLF123U201-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = ""            # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     =                            # (required) from_nodeID
                dnodeprof_to_node       =                            # (required) to_nodeID
            },
            "-tftest" = {                                     # (required) node selector name
                dnodeprof_switchassc_type  = "range"                    # (required) def: ALL | range | ALL_IN_POD *choose range in most cases
                dnodeprof_blockname     = ""          # (required) block name NOTE: APIC seems to choose 8-byte hex value resembling MAC. can be "block1", etc.
                dnodeprof_from_node     =                            # (required) from_nodeID
                dnodeprof_to_node       =                            # (required) to_nodeID
            },
        }
    }
*/

#    ██╗███╗   ██╗████████╗███████╗██████╗ ███████╗ █████╗  ██████╗███████╗    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔════╝    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  ███████║██║     █████╗      ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
#    ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██╔══██║██║     ██╔══╝      ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
#    ██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ██║  ██║╚██████╗███████╗    ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
#    ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles
lfprofile_map = {
    "BLF123U201-LIP-tftest" = {                         # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = "BLF123U201-LIP"   # (optional) Description 0-128chars
    }
    "BLF123U201_124U202-LIP-tftest" = {                 # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "BLF124U202-LIP-tftest" = {                         # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = "BLF124U202-LIP"   # (optional) Description 0-128chars
    }
    "LF110K211-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF110K211_110L212-LIP-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF110L212-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF110M213-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF110M213_110N214-LIP-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF110N214-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF118G218-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF118G218_118H217-LIP-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF118H217-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF134J219-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF134J219-to-FEX-LIP-tftest" = {                   # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF134J219_134J220-LIP-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF134J220-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF134J220-to-FEX-LIP-tftest" = {                   # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF139J215-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF139J215_139K216-LIP-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
    "LF139K216-LIP-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_name_alias       = ""                 # (optional) name alias
        lfprofile_description      = ""                 # (optional) Description 0-128chars
    }
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors/Port Blocks
accportsel_map = {
    "APIC1_2-1-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "GRN_NX03_RTD-tftest" = {                                   # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "GRN_NX04_RTD-tftest" = {                                   # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "NX01_02_VPC-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201_124U202-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = "NX01_02 Black zone to L2out"  # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)      
    }
    "NX03_L201_202_YLW_VPC-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201_124U202-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)     
    }
    "NX04_L201_202_YLW_VPC-tftest" = {                          # (required) key = name 1-64chars
        lfprofile_key          = "BLF123U201_124U202-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "BLF124U202-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "APIC1_2-2-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "BLF124U202-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "GRN_NX03_RTD-tftest" = {                                   # (required) key = name 1-64chars
        lfprofile_key          = "BLF124U202-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "GRN_NX04_RTD-tftest" = {                                   # (required) key = name 1-64chars
        lfprofile_key          = "BLF124U202-LIP-tftest"        # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "APIC2_2-1-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "LF110M213-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "LF110M213-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE-IntProf-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "LF110M213_110N214-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "APIC2_2-2-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "LF110N214-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "LF110N214-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "131G_A1-VPC-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "131G_A2-VPC-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "131G_B1-VPC-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "131G_B2-VPC-tftest" = {                                    # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "FW_PA7050-1_vPC_IntSel-tftest" = {                         # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = "vPC to FW_PA7050-1"           # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "FW_PA7050-2_vPC_IntSel-tftest" = {                         # (required) key = name 1-64chars
        lfprofile_key          = "LF118G218_118H217-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = "vPC to FW_PA7050-2"           # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ASE_InBand-tftest" = {                                     # (required) key = name 1-64chars
        lfprofile_key          = "LF118H217-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "APIC3_2-1-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "LF134J219-to-FEX101-IntSelect-tftest" = {                  # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219-to-FEX-LIP-tftest"  # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE01_IC01_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE01_IC02_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE02_IC01_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE02_IC02_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE03_IC01_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "SE03_IC02_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF134J219_134J220-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "APIC3_2-2-tftest" = {                                      # (required) key = name 1-64chars
        lfprofile_key          = "LF134J220-LIP-tftest"  # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ilo-uddcbpesx201.IntSel-tftest" = {                        # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215-LIP-tftest-tftest"  # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ilo-uddcbpesx202.IntSel-tftest" = {                        # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215-LIP-tftest-tftest"  # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE01_IC01_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE01_IC02_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE02_IC01_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE02_IC02_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE03_IC01_vPC_IntSel-tftest" = {                           # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE03_IC02_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE04_IC01_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "Prod_SE04_IC02_vPC_IntSel-tftest" = {                      # (required) key = name 1-64chars
        lfprofile_key          = "LF139J215_139K216-LIP-tftest" # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ilo-uddcbpesx201.IntSel-tftest" = {                        # (required) key = name 1-64chars
        lfprofile_key          = "LF139K216-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
    "ilo-uddcbpesx202.IntSel-tftest" = {                        # (required) key = name 1-64chars
        lfprofile_key          = "LF139K216-LIP-tftest"         # (required) leaf interface profile assc.
        lfsel_name_alias       = ""                             # (optional) name alias
        ifsel_description      = ""                             # (optional) Description 0-128chars
        ifsel_type             = "range"                        # (required) Def ALL | range (i think choose range)
    }
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups
accportblk_map = {
    "APIC1_2-1-tftest.48.48" = {                    # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC1_2-1-tftest"   # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_fromport     = 48                   # (optional) starting port [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 48                   # (optional) ending port [range]
    }
    "ASE_InBand-tftest.45.45" = {                   # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "ASE_InBand-tftest"  # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 45                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 45                   # (optional) ending port [range]
    }
    "GRN_NX03_RTD-tftest.20.20" = {                 # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "GRN_NX03_RTD-tftest"  # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = "L201 To NX03 Eth2_20" # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 20                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 20                   # (optional) ending port [range]
    }
    "GRN_NX04_RTD-tftest.21.21" = {                 # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "GRN_NX04_RTD-tftest"  # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = "L202 To NX03 Eth2_21" # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 21                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 21                   # (optional) ending port [range]
    }
    "NX01_02_VPC-tftest.46.47" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "NX01_02_VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = "L201 and 202 Port 46-47 to NX01_02 PO102" # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 46                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 47                   # (optional) ending port [range]
    }
    "NX03_L201_202_YLW_VPC.43.43" = {               # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "NX03_L201_202_YLW_VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 43                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 43                   # (optional) ending port [range]
    }
    "NX04_L201_202_YLW_VPC.44.44" = {               # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "NX04_L201_202_YLW_VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 44                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 44                   # (optional) ending port [range]
    }
    "APIC1_2-2.21.21" = {                            # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC1_2-2-tftest"   # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 21                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 21                   # (optional) ending port [range]
    }
    "GRN_NX03_RTD.20.20" = {                        # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "GRN_NX03_RTD-tftest" # (required) access port selector assc.
        portblk_name         = "block3"             # (optional) block name
        portblk_description  = "" # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 21                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 21                   # (optional) ending port [range]
    }
    "GRN_NX04_RTD-tftest.20.20" = {                 # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "GRN_NX04_RTD-tftest"  # (required) access port selector assc.
        portblk_name         = "block3"             # (optional) block name
        portblk_description  = "L202 To NX03 Eth2_21" # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 20                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 20                   # (optional) ending port [range]
    }
    "APIC2_2-1.48.48" = {                              # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC2_2-1-tftest"   # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 48                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 48                   # (optional) ending port [range]
    }
    "APIC2_2-2.48.48" = {                           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC2_2-2-tftest"   # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 48                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 48                   # (optional) ending port [range]
    }
    "131G_A1-VPC.9.9" = {                           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "131G_A1-VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 9                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 9                    # (optional) ending port [range]
    }
    "131G_A2-VPC.10.10" = {                         # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "131G_A2-VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 10                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 10                   # (optional) ending port [range]
    }
    "131G_B1-VPC.11.11" = {                         # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "131G_B1-VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 11                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 11                   # (optional) ending port [range]
    }
    "131G_B2-VPC.12.12" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "131G_B2-VPC-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 12                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 12                   # (optional) ending port [range]
    }
    "FW_PA7050-1_vPC_IntSel.49.49" = {              # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "FW_PA7050-1_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 49                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 49                   # (optional) ending port [range]
    }
    "FW_PA7050-2_vPC_IntSel.50.50" = {              # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "FW_PA7050-2_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 50                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 50                   # (optional) ending port [range]
    }
    "APIC3_2-1.48.48" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC3_2-1-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 48                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 48                   # (optional) ending port [range]
    }
    "LF134J219-to-FEX101-IntSelect.49.49" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "LF134J219-to-FEX101-IntSelect-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 49                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 49                   # (optional) ending port [range]
    }
    "SE01_IC01_vPC_IntSel.1.4" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE01_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 1                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 4                    # (optional) ending port [range]
    }
    "SE01_IC02_vPC_IntSel.5.8" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE01_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 5                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 8                    # (optional) ending port [range]
    }
    "SE02_IC01_vPC_IntSel.9.12" = {                  # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE02_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 9                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 12                   # (optional) ending port [range]
    }
    "SE02_IC02_vPC_IntSel.13.16" = {                # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE02_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 13                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 16                   # (optional) ending port [range]
    }
    "SE03_IC01_vPC_IntSel.17.20" = {                # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE03_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 17                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 20                   # (optional) ending port [range]
    }
    "SE03_IC02_vPC_IntSel.21.24" = {                # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "SE03_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 21                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 24                   # (optional) ending port [range]
    }
    "APIC3_2-2.48.48" = {                           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "APIC3_2-2-tftest"   # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 48                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 48                   # (optional) ending port [range]
    }
    "ilo-uddcbpesx201.IntSel.33.33" = {             # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "ilo-uddcbpesx201.IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 33                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 33                   # (optional) ending port [range]
    }
    "ilo-uddcbpesx202.IntSel.34.34" = {             # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "ilo-uddcbpesx202.IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 34                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 34                   # (optional) ending port [range]
    }
    "Prod_SE01_IC01_vPC_IntSel.1.4" = {             # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE01_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 1                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 4                    # (optional) ending port [range]
    }
    "Prod_SE01_IC02_vPC_IntSel.5.8" = {             # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE01_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 5                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 8                    # (optional) ending port [range]
    }
    "Prod_SE02_IC01_vPC_IntSel.9.12" = {            # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE02_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 9                    # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 12                   # (optional) ending port [range]
    }
    "Prod_SE02_IC02_vPC_IntSel.13.16" = {           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE02_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 13                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 16                   # (optional) ending port [range]
    }
    "Prod_SE03_IC01_vPC_IntSel.17.20" = {           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE03_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 17                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 20                   # (optional) ending port [range]
    }
    "Prod_SE03_IC02_vPC_IntSel.21.24" = {           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE03_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 21                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 24                   # (optional) ending port [range]
    }
    "Prod_SE04_IC01_vPC_IntSel.25.28" = {           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE04_IC01_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = "Prod_SE04_IC01_vPC_IntSel"                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 25                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 28                   # (optional) ending port [range]
    }
    "Prod_SE04_IC02_vPC_IntSel.29.32" = {           # (required) key = key [portselector_name.fromport.toport]
        lfselector_key       = "Prod_SE04_IC02_vPC_IntSel-tftest" # (required) access port selector assc.
        portblk_name         = "block2"             # (optional) block name
        portblk_description  = ""                   # (optional) interface description 0-128chars
        portblk_fromcard     = 1                    # (optional) leaf access port policy group assc.
        portblk_fromport     = 29                   # (optional) starting card slot = 1 for 1RU switches [range]
        portblk_tocard       = 1                    # (optional) ending card slot = 1 for 1RU switches [range]
        portblk_toport       = 32                   # (optional) ending port [range]
    }
}

# access group associates the [interface] policy group to the access port selector
accessgrp_map =  {
    "BLF123U201-LIP.APIC1_2-1" = {                                          # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC1_2-1-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201-LIP.ASE_InBand" = {                                         # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ASE_InBand-tftest"                         # leaf selector assc.
        accgrp_policygrp_key = "ASE_10G-PG-tftest"                          # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201-LIP.GRN_NX03_RTD" = {                                       # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "GRN_NX03_RTD-tftest"                       # leaf selector assc.
        accgrp_policygrp_key = "NX03_GRN_RTD-IntPG-tftest"                  # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201-LIP.GRN_NX04_RTD" = {                                       # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "GRN_NX04_RTD-tftest"                       # leaf selector assc.
        accgrp_policygrp_key = "NX04_GRN_RTD-IntPG-tftest"                  # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201_124U202-LIP.NX01_02_VPC" = {                                # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "NX01_02_VPC-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "NX01_02_BLK_VPC-IntPG-tftest"               # pc/vpc interface policy group assc.
        accgrp_type = "accbundle"                                           # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201_124U202-LIP.NX03_L201_202_YLW_VPC" = {                      # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "NX03_L201_202_YLW_VPC-tftest"              # leaf selector assc.
        accgrp_policygrp_key = "NX03_L201_202_YLW_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF123U201_124U202-LIP.NX04_L201_202_YLW_VPC" = {                      # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "NX04_L201_202_YLW_VPC-tftest"              # leaf selector assc.
        accgrp_policygrp_key = "NX04_L201_202_YLW_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF124U202-LIP.APIC1_2-2" = {                                          # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC1_2-2-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF124U202-LIP.GRN_NX03_RTD" = {                                       # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "GRN_NX03_RTD-tftest"                       # leaf selector assc.
        accgrp_policygrp_key = "NX03_GRN_RTD-IntPG-tftest"                  # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "BLF124U202-LIP.GRN_NX04_RTD" = {                                       # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "GRN_NX04_RTD-tftest"                       # leaf selector assc.
        accgrp_policygrp_key = "NX04_GRN_RTD-IntPG-tftest"                  # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF110M213-LIP.APIC2_2-1" = {                                           # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC2_2-1-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF110M213_110N214-LIP.ASE-IntProf" = {                                 # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ASE-IntProf-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF110N214-LIP.APIC2_2-2" = {                                           # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC2_2-2-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.131G_A1-VPC" = {                                 # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "131G_A1-VPC-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "131G_A1-VPC-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.131G_A2-VPC" = {                                 # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "131G_A2-VPC-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "131G_A2-VPC-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.131G_B1-VPC" = {                                 # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "131G_B1-VPC-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "131G_B1-VPC-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.131G_B2-VPC" = {                                 # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "131G_B2-VPC-tftest"                        # leaf selector assc.
        accgrp_policygrp_key = "131G_B2-VPC-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.FW_PA7050-1_vPC_IntSel" = {                      # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "FW_PA7050-1_vPC_IntSel-tftest"             # leaf selector assc.
        accgrp_policygrp_key = "FW_PA7050-1_vPC-IntPol-tftest"              # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF118G218_118H217-LIP.FW_PA7050-2_vPC_IntSel" = {                      # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "FW_PA7050-2_vPC_IntSel-tftest"             # leaf selector assc.
        accgrp_policygrp_key = "FW_PA7050-2_vPC-IntPol-tftest"              # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219-LIP.APIC3_2-1" = {                                           # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC3_2-1-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219-to-FEX-LIP.LF134J219-to-FEX101-IntSelect" = {                # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "LF134J219-to-FEX101-IntSelect-tftest"      # leaf selector assc.
        accgrp_policygrp_key = "134J219-101-FEXProf-tftest"                 # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE01_IC01_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE01_IC01_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE01_IC01_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE01_IC02_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE01_IC02_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE01_IC02_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE02_IC01_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE02_IC01_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE02_IC01_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE02_IC02_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE02_IC02_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE02_IC02_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE03_IC01_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE03_IC01_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE03_IC01_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J219_134J220-LIP.SE03_IC02_vPC_IntSel" = {                        # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "SE03_IC02_vPC_IntSel-tftest"               # leaf selector assc.
        accgrp_policygrp_key = "134I_SE03_IC02_HP_VPC-IntPG-tftest"         # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF134J220-LIP.APIC3_2-2" = {                                           # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "APIC3_2-2-tftest"                          # leaf selector assc.
        accgrp_policygrp_key = "APIC_InBand-IntPG-tftest"                   # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215-LIP.ilo-uddcbpesx201.IntSel" = {                             # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ilo-uddcbpesx201.IntSel-tftest"            # leaf selector assc.
        accgrp_policygrp_key = "Bare_Metal_10G-IntPG-tftest"                # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215-LIP.ilo-uddcbpesx202.IntSel" = {                             # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ilo-uddcbpesx202.IntSel-tftest"            # leaf selector assc.
        accgrp_policygrp_key = "Bare_Metal_10G-IntPG-tftest"                # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE01_IC01_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE01_IC01_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139J_Prod_SE01_IC01_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE01_IC02_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE01_IC02_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139J_Prod_SE01_IC02_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE02_IC01_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE02_IC01_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139J_Prod_SE02_IC01_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE02_IC02_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE02_IC02_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139J_Prod_SE02_IC02_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE03_IC01_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE03_IC01_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139K_Prod_SE03_IC01_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE03_IC02_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE03_IC02_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139K_Prod_SE03_IC02_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE04_IC01_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE04_IC01_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139K_Prod_SE04_IC01_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139J215_139K216-LIP.Prod_SE04_IC02_vPC_IntSel" = {                   # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "Prod_SE04_IC02_vPC_IntSel-tftest"          # leaf selector assc.
        accgrp_policygrp_key = "139K_Prod_SE04_IC02_HP_VPC-IntPG-tftest"    # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139K216-LIP.ilo-uddcbpesx201.IntSel" = {                             # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ilo-uddcbpesx201.IntSel-tftest"            # leaf selector assc.
        accgrp_policygrp_key = "Bare_Metal_10G-IntPG-tftest"                # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
    "LF139K216-LIP.ilo-uddcbpesx202.IntSel" = {                             # (required) key = key: leafprofilename.leafselectorname used for human associations
        accgrp_lfselector_key = "ilo-uddcbpesx202.IntSel-tftest"            # leaf selector assc.
        accgrp_policygrp_key = "Bare_Metal_10G-IntPG-tftest"                # pc/vpc interface policy group assc.
        accgrp_type = "accportgrp"                                          # type = "accportgrp" (access) | "accbundle" (pc/vpc)
    }
}

#    ███████╗███████╗██╗  ██╗    ██████╗ ██████╗  ██████╗ ███████╗██╗██╗     ███████╗
#    ██╔════╝██╔════╝╚██╗██╔╝    ██╔══██╗██╔══██╗██╔═══██╗██╔════╝██║██║     ██╔════╝
#    █████╗  █████╗   ╚███╔╝     ██████╔╝██████╔╝██║   ██║█████╗  ██║██║     █████╗  
#    ██╔══╝  ██╔══╝   ██╔██╗     ██╔═══╝ ██╔══██╗██║   ██║██╔══╝  ██║██║     ██╔══╝  
#    ██║     ███████╗██╔╝ ██╗    ██║     ██║  ██║╚██████╔╝██║     ██║███████╗███████╗
#    ╚═╝     ╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝╚══════╝
                                                                                        
# Interfaces | Leaf Interfaces | Profiles | Leaf FEX Profiles
lffexprofile_map = {
    "134J219-101-FEXProf-tftest" = {                 # (required) key = name 1-64chars
        lffexprofile_name_alias       = ""           # (optional) name alias
        lffexprofile_description      = ""           # (optional) Description 0-128chars
    }
    "134J220-102-FEXProf-tftest" = {                 # (required) key = name 1-64chars
        lffexprofile_name_alias       = ""           # (optional) name alias
        lffexprofile_description      = ""           # (optional) Description 0-128chars
    }
    "FEX-100-FEXProf-tftest" = {                     # (required) key = name 1-64chars
        lffexprofile_name_alias       = ""           # (optional) name alias
        lffexprofile_description      = ""           # (optional) Description 0-128chars
    }
    "Fex117_L217-LIP-tftest" = {                     # (required) key = name 1-64chars
        lffexprofile_name_alias       = ""           # (optional) name alias
        lffexprofile_description      = ""           # (optional) Description 0-128chars
    }
    "Fex118_L218-LIP-tftest" = {                     # (required) key = name 1-64chars
        lffexprofile_name_alias       = ""           # (optional) name alias
        lffexprofile_description      = ""           # (optional) Description 0-128chars
    }
}

# Interfaces | Leaf Interfaces | Profiles | Leaf FEX Profiles | Leaf FEX Policy Groups
lffexpolgrp_map = {
    "134J219-101-FEXProf-tftest" = {                                # (required) key = name 1-64chars FEX Policy Group
        fexpolgrp_key               = "134J219-101-FEXProf-tftest"  # (required) FEX profile assc.
        fexpolgrp__name_alias       = ""                            # (optional) name alias
        fexpolgrp__description      = ""                            # (optional) Description 0-128chars

    }
    "134J220-102-FEXProf-tftest" = {                                # (required) key = name 1-64chars FEX Policy Group
        fexpolgrp_key               = "134J220-102-FEXProf-tftest"  # (required) FEX profile assc.
        fexpolgrp__name_alias       = ""                            # (optional) name alias
        fexpolgrp__description      = ""                            # (optional) Description 0-128chars

    }
    "FEX-100-FEXProf-tftest" = {                                    # (required) key = name 1-64chars FEX Policy Group
        fexpolgrp_key               = "FEX-100-FEXProf-tftest"  # (required) FEX profile assc.
        fexpolgrp__name_alias       = ""                            # (optional) name alias
        fexpolgrp__description      = ""                            # (optional) Description 0-128chars

    }
    "Fex117_L217-LIP-tftest" = {                                    # (required) key = name 1-64chars FEX Policy Group
        fexpolgrp_key               = "Fex117_L217-LIP-tftest"  # (required) FEX profile assc.
        fexpolgrp__name_alias       = ""                            # (optional) name alias
        fexpolgrp__description      = ""                            # (optional) Description 0-128chars

    }
    "Fex118_L218-LIP-tftest" = {                                    # (required) key = name 1-64chars FEX Policy Group
        fexpolgrp_key               = "Fex118_L218-LIP-tftest"  # (required) FEX profile assc.
        fexpolgrp__name_alias       = ""                            # (optional) name alias
        fexpolgrp__description      = ""                            # (optional) Description 0-128chars

    }
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Selectors/Port Blocks for fex
fexaccportsel_map = {
    "Fex118-tftest" = {                                             # (required) key = name 1-64chars
        fexprofile_key            = "LF118G218-LIP-tftest"          # (required) leaf interface profile assc.
        fexifsel_description      = ""                              # (optional) Description 0-128chars
        fexifsel_type             = "range"                         # (required) Def ALL | range (i think choose range)
    }
    "Fex117-tftest" = {                                             # (required) key = name 1-64chars
        fexprofile_key            = "LF118H217-LIP-tftest"          # (required) leaf interface profile assc.
        fexifsel_description      = ""                              # (optional) Description 0-128chars
        fexifsel_type             = "range"                         # (required) Def ALL | range (i think choose range)
    }
}

# Interfaces | Leaf Interfaces | Profiles | Leaf Interface Profiles | Access Port Blocks/Access Groups for fex
fexaccportblk_map = {
    "Fex118-tftest.1.4" = {                         # (required) key = key [portselector_name.fromport.toport]
        fexlfselector_key       = "Fex118-tftest"   # (required) access port selector assc.
        fexportblk_name         = "block2"          # (optional) block name
        fexportblk_description  = ""                # (optional) interface description 0-128chars
        fexportblk_fromcard     = 1                 # (optional) starting card slot = 1 for 1RU switches [range]
        fexportblk_fromport     = 1                 # (optional) starting port [range]
        fexportblk_tocard       = 1                 # (optional) ending card slot = 1 for 1RU switches [range]
        fexportblk_toport       = 4                 # (optional) ending port [range]
    }
    "Fex117-tftest.1.4" = {                         # (required) key = key [portselector_name.fromport.toport]
        fexlfselector_key       = "Fex117-tftest"   # (required) access port selector assc.
        fexportblk_name         = "block2"          # (optional) block name
        fexportblk_description  = ""                # (optional) interface description 0-128chars
        fexportblk_fromcard     = 1                 # (optional) starting card slot = 1 for 1RU switches [range]
        fexportblk_fromport     = 1                 # (optional) starting port [range]
        fexportblk_tocard       = 1                 # (optional) ending card slot = 1 for 1RU switches [range]
        fexportblk_toport       = 4                 # (optional) ending port [range]
    }
}

# access group associates the [interface] policy group to the access port selector
fexaccessgrp_map =  {
    "LF118G218-LIP-tftest.Fex118-tftest" = {                    # (required) key = key: leafprofilename.leafselectorname used for human associations
        fexaccgrp_lfselector_key = "Fex118-tftest"              # leaf selector assc.
        fexaccgrp_fexID = "118" #comma-separated if > 1         # fexid -- static value in "main" code unless otherwise needed
        fexaccgrp_policygrp_key = "Fex118_L218-LIP-tftest"      # pc/vpc interface policy group assc.
    }
    "LF118H217-LIP-tftest.Fex117-tftest" = {                    # (required) key = key: leafprofilename.leafselectorname used for human associations
        fexaccgrp_lfselector_key = "Fex117-tftest"              # leaf selector assc.
        fexaccgrp_fexID = "117" #comma-separated if > 1         # fexid -- static value in "main" code unless otherwise needed
        fexaccgrp_policygrp_key = "Fex117_L217-LIP-tftest"      # pc/vpc interface policy group assc.
    }
}

#    ██╗     ███████╗ █████╗ ███████╗     ██████╗ ██╗   ██╗███████╗██████╗ ██████╗ ██╗██████╗ ███████╗███████╗
#    ██║     ██╔════╝██╔══██╗██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗██╔══██╗██║██╔══██╗██╔════╝██╔════╝
#    ██║     █████╗  ███████║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝██████╔╝██║██║  ██║█████╗  ███████╗
#    ██║     ██╔══╝  ██╔══██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══██╗██║██║  ██║██╔══╝  ╚════██║
#    ███████╗███████╗██║  ██║██║         ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║██║  ██║██║██████╔╝███████╗███████║
#    ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝          ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝╚══════╝
                                                                                                         
# Interfaces | Leaf Interfaces | Overrides
# Note: Overrides config (the keys, and node/port ID values are specific to the simulator and must be adapted to the
#       production fabric prior to production deployment.
# Note: Portpolicygrp CANNOT be null--Must create a leaf interface policy group with null (or default) values to simulate
#       an override policy with no interface policy group policy defined.
lfoverides_map = {
    "201_eth1_1" = {                                           # (required) key = name 1-64chars
        lfoverides_description      = "Ixia port 14"            # (optional) Description 0-128chars
        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
        lfoverides_nodeID           = "201"                     # (required) node ID (switch ID)
        lfoverides_portID           = "eth1/1"                  # (required) port ID
        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
    }
#    "201_eth1_51" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = "Ixia port 14"            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "201"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/51"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "217_eth1_50" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "217"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/50"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "217_eth1_51" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "217"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/51"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "217_eth1_52" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "217"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/52"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "218_eth1_46" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "218"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/46"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "218_eth1_47" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "218"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/47"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "218_eth1_48" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "218"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/48"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "218_eth1_51" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "218"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/51"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
#    "218_eth1_52" = {                                           # (required) key = name 1-64chars
#        lfoverides_description      = " "            # (optional) Description 0-128chars
#        lfoverides_podID            = "1"                       # (required) pod ID (typically 1)
#        lfoverides_nodeID           = "218"                     # (required) node ID (switch ID)
#        lfoverides_portID           = "eth1/52"                  # (required) port ID
#        lfoverides_portpolicygrp    = "Nullpolicy-tftest"       # (required) choose from Leaf Access Port Policy options
#    }
}


#   ██████╗  ██████╗ ██╗     ██╗ ██████╗██╗███████╗███████╗
#   ██╔══██╗██╔═══██╗██║     ██║██╔════╝██║██╔════╝██╔════╝
#   ██████╔╝██║   ██║██║     ██║██║     ██║█████╗  ███████╗
#   ██╔═══╝ ██║   ██║██║     ██║██║     ██║██╔══╝  ╚════██║
#   ██║     ╚██████╔╝███████╗██║╚██████╗██║███████╗███████║
#   ╚═╝      ╚═════╝ ╚══════╝╚═╝ ╚═════╝╚═╝╚══════╝╚══════╝
                                                                                                                                                                                
# Interfaces | Leaf Switches | Policy Groups | Leaf Access Port
lfaccptpolgrp_map = {
    "Nullpolicy-tftest" = {                                   # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = "policy with 0 config"    # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "default-tftest"          # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "default-tftest"          # (required) minimum: default Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "default-tftest"          # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "default-tftest"       # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "APIC_InBand-IntPG-tftest" = {                                   # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = ""                        # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-On-tftest"          # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "default-tftest"          # (required) minimum: default Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-Off-tftest"          # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "InBand-AEP-tftest"       # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "ASE_10G-PG-tftest" = {                                          # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = ""                        # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-On-tftest"          # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "10G-tftest"          # (required) minimum: default Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-Off-tftest"          # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "Prod_Network-AEP-tftest"       # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "Fw-intPol-tftest" = {                                          # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = ""                        # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-Off-tftest"          # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "100G-tftest"          # (required) minimum: default Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-Off-tftest"          # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "Prod_Network-AEP-tftest"       # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "Leaf_Access-IntPG-tftest" = {                                          # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = ""                        # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-Off-tftest"          # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "1G-tftest"          # (required) minimum: default Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-Off-tftest"          # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "Prod_Compute-AEP-tftest"       # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "NX03_GRN_RTD-IntPG-tftest" = {                                  # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = "L3 from NX03 to ACI BL"  # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-Off-tftest"         # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "10G-tftest"              # (required) Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-On-tftest"           # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "Prod_Network-AEP-tftest" # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
    "NX04_GRN_RTD-IntPG-tftest" = {                                  # key = name (required) 1-64chars
        lfaccptpolgrp_name_alias         = ""                        # (optional) Name_alias
        lfaccptpolgrp_description        = "L3 from NX04 to ACI BL"  # (optional) Description 0-128chars
        ###############################################################################################################
        ###### DOMAINS ASSOCIATED TO OTHER OBJECTS (SOURCE RELATIONSHIPS) #############################################
        ###############################################################################################################
        #lfaccptpolgrp_spanVSrcGrp       = ""                        # (optional) VSPAN Source Group Assc.
        #lfaccptpolgrp_stormctrlIfPol    = ""                        # (optional) Storm Control Interface Policy Assc.
        #lfaccptpolgrp_poeIfPol          = ""                        # (optional) POE Interface Policy Assc.
        lfaccptpolgrp_lldpIfPol          = "LLDP-Off-tftest"         # (optional) LLDP Policy Assc.
        #lfaccptpolgrp_macsecIfPol       = ""                        # (optional) MACsec Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Policy Assc.
        lfaccptpolgrp_fabricHIfPol       = "10G-tftest"              # (required) Link Level Policy Assc.
        #lfaccptpolgrp_netflowMonitorPol = ""                        # (optional) Netflow Monitor Policy Assc.
        #lfaccptpolgrp_l2PortAuthPol     = ""                        # (optional) 802.1x Port Authentication policy Assc.
        #lfaccptpolgrp_mcpIfPol          = ""                        # (optional) MCP Interface Policy Assc.
        #lfaccptpolgrp_l2PortSecurityPol = ""                        # (optional) L2 PortSecurity Policy Assc.
        #lfaccptpolgrp_coppIfPol         = ""                        # (optional) CoPP Policy Assc.
        #lfaccptpolgrp_spanVDestGrp      = ""                        # (optional) VSPAN Destination Group Assc.
        #lfaccptpolgrp_dwdmIfPol         = ""                        # (optional) DWDM Policy Assc.
        #lfaccptpolgrp_qosPfcIfPol       = ""                        # (optional) Interface Priority Flow Control Policy Assc.
        #lfaccptpolgrp_qosSdIfPol        = ""                        # (optional) Slow Drain Interface Policy Assc.
        #lfaccptpolgrp_monInfraPol       = ""                        # (optional) Monitoring Policy Assc.
        #lfaccptpolgrp_fcIfPol           = ""                        # (optional) Fibre Channel Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Ingress Policy Assc.
        lfaccptpolgrp_cdpIfPol           = "CDP-On-tftest"           # (optional) CDP Policy Assc.
        #lfaccptpolgrp_l2IfPol           = ""                        # (optional) L2 Interface Policy Assc.
        #lfaccptpolgrp_stpIfPol          = ""                        # (optional) Spanning Tree Protocol Interface Policy Assc.
        #lfaccptpolgrp_qosDppPol         = ""                        # (optional) Data Plane Egress Policy Assc.
        lfaccptpolgrp_infraAttEntityP    = "Prod_Network-AEP-tftest" # (optional) Attached Entity Profile Assc.
        #lfaccptpolgrp_l2InstPol         = ""                        # (optional) L2 MTU Policy Assc.
    }
}

# Interfaces | Leaf Switches | Policy Groups | PC Interfaces/VPC Interfaces
# Note: lfpcif_lagtype attribute (link or node) distinguishes between PortChannel or Virtual PortChannel
lfpcif_map = {
    "NX03_GRN_PO-intPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = "GRN VRF to Nx03 Core VRF"    # (optional) Description 0-128chars
        lfpcif_lagtype          = "link"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = ""                            # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "NX04_GRN_PO-IntPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = "GRN VRF to Nx04 Core VRF"    # (optional) Description 0-128chars
        lfpcif_lagtype          = "link"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = ""                            # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "110H_A1-VPC-tftest" = {                                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "110H_A2-VPC-tftest" = {                                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "110H_B1-VPC-tftest" = {                                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "110H_B2-VPC-tftest" = {                                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "131G_A1-VPC-IntPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "131G_A2-VPC-IntPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "131G_B1-VPC-IntPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "131G_B2-VPC-IntPG-tftest" = {                                     # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"               # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"             # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "134I_SE01_IC01_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "134I_SE01_IC02_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "134I_SE02_IC01_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "134I_SE02_IC02_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "134I_SE03_IC01_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "134I_SE03_IC02_HP_VPC-IntPG-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "NonProd_Compute-AEP-tftest"  # (optional) Attached Entity Profile Assc.
    }
    "139J_Prod_SE01_IC01_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139J_Prod_SE01_IC02_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139J_Prod_SE02_IC01_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139J_Prod_SE02_IC02_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139K_Prod_SE03_IC01_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139K_Prod_SE03_IC02_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139K_Prod_SE04_IC01_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "139K_Prod_SE04_IC02_HP_VPC-IntPG-tftest" = {                      # (required) key = name 1-64chars
        lfpcif_description      = ""                            # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Compute-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "FW_PA7050-1_vPC-IntPol-tftest" = {                                # (required) key = name 1-64chars
        lfpcif_description      = "vPC to PA-7050 node 1"       # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "Auto-tftest"                 # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "FW_PA7050-2_vPC-IntPol-tftest" = {                                # (required) key = name 1-64chars
        lfpcif_description      = "vPC to PA-7050 node 2"       # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "Auto-tftest"                 # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "NX01_02_BLK_VPC-IntPG-tftest" = {                                         # (required) key = name 1-64chars
        lfpcif_description      = "L2Out from NX01_02 to ACI fabric"    # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                                # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"                  # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                          # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"                       # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"                     # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"             # (optional) Attached Entity Profile Assc.
    }
    "NX03_L201_202_YLW_VPC-IntPG-tftest" = {                                   # (required) key = name 1-64chars
        lfpcif_description      = "L2Out from NX01_02 to ACI fabric"    # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                                # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"                  # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                          # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"                       # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"                     # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"             # (optional) Attached Entity Profile Assc.
    }
    "NX04_L201_202_YLW_VPC-IntPG-tftest" = {                                   # (required) key = name 1-64chars
        lfpcif_description      = "L2Out from NX01_02 to ACI fabric"    # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                                # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"                  # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                          # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-On-tftest"                       # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-Off-tftest"                     # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"             # (optional) Attached Entity Profile Assc.
    }
    "Test_FW_PA7050-1_vPC-IntPol-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = "vPC to PA-7050 node 1"       # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
    "Test_FW_PA7050-2_vPC-IntPol-tftest" = {                           # (required) key = name 1-64chars
        lfpcif_description      = "vPC to PA-7050 node 1"       # (optional) Description 0-128chars
        lfpcif_lagtype          = "node"                        # (required) Link Aggregation Type def: link | node | not-aggregated | fc-link (link=port-channel, node=vpc)
        lfpcif_pcpol            = "LACP-Active-tftest"          # (optional) Port Channel Policy Assc.
        lfpcif_fabricHIfPol     = "10G-tftest"                  # (optional) Link Level Policy Assc.
        lfpcif_cdpIfPol         = "CDP-Off-tftest"              # (optional) CDP Policy Assc.
        lfpcif_lldpIfPol        = "LLDP-On-tftest"              # (optional) LLDP Policy Assc.
        lfpcif_infraAttEntityP  = "Prod_Network-AEP-tftest"     # (optional) Attached Entity Profile Assc.
    }
}

# Interfaces | Leaf Switches | Policy Groups | Leaf Breakout Port Groups
lfbrkoutprtgrp_map = {
    "40G-10G-tftest" = {                            # (required) key = name 1-64chars
        lfbrkoutprtgrp_description  = ""            # (optional) Description 0-128chars
        lfbrkoutprtgrp_brkoutmap    = "10g-4x"      # (required) def: none | 10g-4x | 25g-4x | 100g-2x | 50g-8x | 100g-4x
    }
}


# Policies | Switch | Virtual Port Channel Default
vpcdefault_map = {
    "VPC10-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "201"  # (optional) switch pair node ID
        vpcdef_switch2      = "202"  # (optional) switch pair node ID
        vpcdef_domainpolicy = ""     # (optional) VPC domain policy
        vpcdef_groupID      = "10"   # (required) logical pair ID
    }
    "VPC11-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "211"  # (optional) 
        vpcdef_switch2      = "212"  # (optional)
        vpcdef_domainpolicy = ""     # (optional)
        vpcdef_groupID      = "11"   # (required) 
    }
    "VPC12-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "213"  # (optional) 
        vpcdef_switch2      = "214"  # (optional)
        vpcdef_domainpolicy = ""     # (optional)
        vpcdef_groupID      = "12"   # (required) 
    }
    "VPC14-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "217"  # (optional) 
        vpcdef_switch2      = "218"  # (optional)
        vpcdef_domainpolicy = ""     # (optional)
        vpcdef_groupID      = "14"   # (required) 
    }
    "VPC15-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "219"  # (optional) 
        vpcdef_switch2      = "220"  # (optional)
        vpcdef_domainpolicy = ""     # (optional)
        vpcdef_groupID      = "15"   # (required) 
    }
    "VPC16-tftest" = {               # (required) name 1-64chars
        vpcdef_switch1      = "215"  # (optional) 
        vpcdef_switch2      = "216"  # (optional)
        vpcdef_domainpolicy = ""     # (optional)
        vpcdef_groupID      = "16"   # (required) 
    }
}
 
# Policies | Interface | Link Level
linklevel_map = {
    "default-tftest" = {                 # (required) key = name 1-64chars
        lnklvl_autoneg       = "on"      # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "inherit" # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
    "1G-tftest" = {                           # (required) key = name 1-64chars
        lnklvl_autoneg       = "off"     # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "1G"      # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
    "10G-tftest" = {                          # (required) key = name 1-64chars
        lnklvl_autoneg       = "off"     # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "10G"      # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
    "40G-tftest" = {                          # (required) key = name 1-64chars
        lnklvl_autoneg       = "off"     # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "40G"     # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
    "100G-tftest" = {                    # (required) key = name 1-64chars
        lnklvl_autoneg       = "off"     # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "100G"    # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
    "Auto-tftest" = {                    # (required) key = name 1-64chars
        lnklvl_autoneg       = "on"      # (optional) def: on | off
        lnklvl_description   = ""        # (optional) 0-128chars
        lnklvl_fecmode       = "inherit" # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvl_linkdebounce  = "100"     # (optional) def: 100 <disabled = 0>
        lnklvl_name_alias    = ""        # (optional)
        lnklvl_speed         = "inherit" # (optional) def: inherit | Unspecified | 100M | 1G | 10G | 25G | 40G | 50G | 100G | 200G | 400G
    }
}
 
# # Policies | Interface | Link Level Flow Control
linklevelflowcontrol_map = {
    "default" = {                           # (required) key = name 1-64chars
        lnklvlfc_rcvadminstate  = "off"     # (optional) def: off | on
        lnklvlfc_sendadminstate = "off"     # (optional) def: off | on
        }
    "lnklvlfc-tftest" = {                       # (required) key = name 1-64chars
        lnklvlfc_rcvadminstate  = "on"      # (optional) def: inherit | CL91-RS-FEC | CL74-FC-FEC | IEEE-RS-FEC | CONS16-RS-FEC | KP-FEC | DISABLE-FEC
        lnklvlfc_sendadminstate = "on"      # (optional) def: 100 <disabled = 0>
        }
    }

# # Policies | Interface | Priority Flow Control
priorityflowcontrol_map = {
    "default" = {                  # (required) key = name 1-64chars
        pfc_description  = ""      # (optional)
        pfc_adminstate   = "auto"  # def: auto | off | on
        }
    "pfc-tftest" = {               # (required) key = name 1-64chars
        pfc_description  = ""      # (optional)
        pfc_adminstate   = "on"    # def: auto | off | on
        }
    }
 
# # Policies | Interface | Link Flap
linkflap_map = {
    "default" = {                    # (required) key = name 1-64chars
        lnkflap_description = ""     # (optional) 0-128chars
        lnkflap_maxerrors   = "30"   # max flaps allowed per time def: 30  (min 2 max 30)
        lnkflap_maxflapsec  = "420"  # time allowed for Max flaps def: 420 (min 5 max 420)
        }
    "lnkflap-tftest" = {             # (required) key = name 1-64chars
        lnkflap_description = ""     # (optional) 0-128chars
        lnkflap_maxerrors   = "30"   # max flaps allowed per time def: 30  (min 2 max 30)
        lnkflap_maxflapsec  = "420"  # time allowed for Max flaps def: 420 (min 5 max 420)
        }
    }
 
# Policies | Interface | CDP Interface
cdp_map = {
    "default-tftest" = {                 # (required) key = name 1-64chars
        cdp_name_alias     = ""          # (optional)
        cdp_description    = ""          # (optional) 0-128chars
        cdp_admin_st    = "disabled"     # (optional) def: enabled | disabled
    }
    "CDP-Off-tftest" = {                 # (required) key = name 1-64chars
        cdp_name_alias     = ""          # (optional)
        cdp_description    = ""          # (optional) 0-128chars
        cdp_admin_st    = "disabled"     # (optional) def: enabled | disabled
    }
    "CDP-On-tftest" = {                  # (required) key = name 1-64chars
        cdp_name_alias     = ""          # (optional)
        cdp_description    = ""          # (optional) 0-128chars
        cdp_admin_st    = "enabled"      # (optional) def: enabled | disabled
    }
}

# Policies | Interface | LLDP Interface
lldp_map = {
    "default-tftest" = {                  # (required) key = name 1-64chars
        lldp_name_alias     = ""          # (optional)
        lldp_description    = ""          # (optional) 0-128chars
        lldp_admin_rx_st    = "enabled"   # (optional) def: enabled | disabled
        lldp_admin_tx_st    = "enabled"   # (optional) def: enabled | disabled
    }
    "LLDP-Off-tftest" = {                 # (required) key = name 1-64chars
        lldp_name_alias     = ""          # (optional)
        lldp_description    = ""          # (optional) 0-128chars
        lldp_admin_rx_st    = "disabled"  # (optional) def: enabled | disabled
        lldp_admin_tx_st    = "disabled"  # (optional) def: enabled | disabled
    }
    "LLDP-On-tftest" = {                  # (required) key = name 1-64chars
        lldp_name_alias     = ""          # (optional)
        lldp_description    = ""          # (optional) 0-128chars
        lldp_admin_rx_st    = "enabled"   # (optional) def: enabled | disabled
        lldp_admin_tx_st    = "enabled"   # (optional) def: enabled | disabled
    }
}

# Policies | Interface | NetFlow

# Policies | Interface | Port Channel
portchannel_map = {
    "default-tftest" = {                # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "off" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
    "LACP-Active-tftest" = {            # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "active" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
    "MAC-Pin-tftest" = {                # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "mac-pin" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
    "Static-On-tftest" = {              # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "off" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
    "LACP_MAC_Pinning-tftest" = {       # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "mac-pin" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
    "ACI_Prod_VDSwitch_lacpLagPol-tftest" = {  # (required) key = name 1-64chars
        portchannel_description = ""    # (optional) 0-128chars
        portchannel_name_alias  = ""    # (optional)
        portchannel_mode        = "mac-pin" # def: off | active | passive |mac-pin | mac-pin-nicload | explicit-failover
        portchannel_control     = "fast-sel-hot-stdby,graceful-conv,susp-individual" # def(d): symmetric-hash | (d) susp-individual | (d) graceful-conv | load-defer | (d) fast-sel-hot-stdby 
        portchannel_minlinks    = "1"   # def: MinLink in the port channel
        portchannel_maxlinks    = "16"  # def: MaxLink in the port channel
    }
}
 
# Policies | Interface | Port Channel Member
portchannelmember_map = {
    "default-tftest" = {                        # (required) key = name 1-64chars
        portchannelmbr_description = ""         # (optional) 0-128chars
        portchannelmbr_name_alias  = ""         # (optional)
        portchannelmbr_priority    = "32768"    # def: 32768
        portchannelmbr_txrate      = "normal"   # def: normal | fast 
    }
}
 
# Policies | Interface | Spanning Tree Interface
stpif_map = {
    "default-tftest" = {                    # (required) key = name 1-64chars
        stpif_description = ""              # (optional) 0-128chars
        stpif_name_alias  = ""              # (optional)
        stpif_ctrl        = "unspecified"   # def: unspecified | bpdu-guard | bpdu-filter 
    }
    "BPDU_Filter-tftest" = {                # (required) key = name 1-64chars
        stpif_description = ""              # (optional) 0-128chars
        stpif_name_alias  = ""              # (optional)
        stpif_ctrl        = "bpdu-filter"   # def: unspecified | bpdu-guard | bpdu-filter 
    }
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
# note: may need a separate rest call for infra provider access as the devnet resource doesn't have feature for infra:ProvAcc
# aka the checkbox for "infra" in GUI  -- only default policy has "infra" checked as of 5/2021.

# aaep_map = {
#   "Prod_Network-AEP-tftest" = { # (required) key = name 1-64chars
#       name                = "Prod_Network-AEP-tftest"
#       aaep_name_alias     = ""  # (optional) 
#       aaep_description    = ""  # (optional)
#       #aaep_RsAccessDomain = "" # MUST be String List (how do I do that??) # (optional) Domain associated to interfaces
#   }
#}

### Example Code for advanced processing of AAEP resources ###
# The AAEP is technically one of the most complex resources to process due to the many relationships it 
# has with other class resources. Essentially, we build our map {list} of AAEP {objects} in aaep_map.
# Then we associate each AAEP with the related objects (i.e Physdom, L3Dom, etc) within each of those
# respective maps.

aaep_map = {
    InBand-AEP-tftest = {                               # (required) Map key - Must match aaep_name
        aaep_name = "InBand-AEP-tftest"                 # (required) Name 1-64chars
        aaep_name_alias = ""                            # (optional) 
        aaep_description = ""                           # (optional)
        enable_infra = false                            # (required) Enable Infra [GUI Checkbox] Boolean True | false
    }
    NonProd_Compute-AEP-tftest = {                      # (required) Map key - Must match aaep_name
        aaep_name = "NonProd_Compute-AEP-tftest"        # (required) Name 1-64chars
        aaep_name_alias = ""                            # (optional)
        aaep_description = ""                           # (optional)
        enable_infra = false                            # (required) Enable Infra [GUI Checkbox] Boolean True | false
    }
    Prod_Compute-AEP-tftest = {                         # (required) Map key - Must match aaep_name
        aaep_name = "Prod_Compute-AEP-tftest"           # (required) Name 1-64chars
        aaep_name_alias = ""                            # (optional)
        aaep_description = ""                           # (optional)
        enable_infra = false                            # (required) Enable Infra [GUI Checkbox] Boolean True | false
    }
    Prod_Network-AEP-tftest = {                         # (required) Map key - Must match aaep_name
        aaep_name = "Prod_Network-AEP-tftest"           # (required) Name 1-64chars
        aaep_name_alias = ""                            # (optional)
        aaep_description = ""                           # (optional)
        enable_infra = false                            # (required) Enable Infra [GUI Checkbox] Boolean True | false
    }
    default-tftest = {                                  # (required) Map key - Must match aaep_name
        aaep_name = "default"                           # (required) Name 1-64chars
        aaep_name_alias = ""                            # (optional)
        aaep_description = ""                           # (optional)
        enable_infra = false                             # (required) Enable Infra [GUI Checkbox] Boolean True | false
    }
}
#aaep_to_l2dom_map = {  # we currently don't have L2 domain configurations -- placeholder
#    oob_3750 = {
#        aaep_key = "oob_3750"
#        l2dom_key = "oob_3750"
#    }
#}
aaep_to_physdom_map = {
    InBand-AEP-tftest = {                               # (required) Map key - Must match aaep_key
        aaep_key = "InBand-AEP-tftest"                  # (required) AAEP Relationship Association -- Must match map key
        physdom_key = "InBand-PhyDom-tftest"            # (optional) Physical Domain Relationship Association from key = name in physdom_map
    }
    NonProd_Compute-AEP-tftest = {                      # (required) Map key - Must match aaep_key
        aaep_key = "NonProd_Compute-AEP-tftest"         # (required) AAEP Relationship Association -- Must match map key
        physdom_key = "NonProd_Compute-PhyDom-tftest"   # (optional) Physical Domain Relationship Association from key = name in physdom_map
    }
    Prod_Compute-AEP-tftest = {                         # (required) Map key - Must match aaep_key
        aaep_key = "Prod_Compute-AEP-tftest"            # (required) AAEP Relationship Association -- Must match map key
        physdom_key = "Prod_Compute-PhyDom-tftest"      # (optional) Physical Domain Relationship Association from key = name in physdom_map
    }
    Prod_Network-AEP-tftest = {                         # (required) Map key - Must match aaep_key
        aaep_key = "Prod_Network-AEP-tftest"            # (required) AAEP Relationship Association -- Must match map key
        physdom_key = "Prod_Network-PhyDom-tftest"      # (optional) Physical Domain Relationship Association from key = name in physdom_map
    }
}

#aaep_to_vmmdom_map = {  # -- placeholder for future config
#    NonProd_Compute-AEP-tftest = {                     # (required) Map key - Must match aaep_key
#        type = "dvs"                                   # TYPE TBD
#        aaep_key = "NonProd_Compute-AEP-tftest"        # (required) AAEP Relationship Association -- Must match map key
#        vmmdom_key = "ACI_Non_Prod_VDSwitch            # (optional) VMM Domain Relationship Association from key = name in physdom_map
#    }
#    Prod_Compute-AEP-tftest = {                        # (required) Map key - Must match aaep_key
#        type = "dvs"                                   # TYPE TBD
#        aaep_key = "Prod_Compute-AEP-tftest"           # (required) AAEP Relationship Association -- Must match map key
#        vmmdom_key = "ACI_Prod_VDSwitch                # (optional) VMM Domain Relationship Association from key = name in physdom_map
#    }
#}

aaep_to_l3dom_map = {
    Prod_Network-AEP-tftest = {                        # (required) Map key - Must match aaep_key
        aaep_key = "Prod_Network-AEP-tftest"           # (required) AAEP Relationship Association -- Must match map key
        l3dom_key = "Prod_Network-L3Dom-tftest"        # (optional) L3 Domain Relationship Association from key = name in l3dom_map
    }
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

#    ██████╗  ██████╗  ██████╗ ██╗     ███████╗
#    ██╔══██╗██╔═══██╗██╔═══██╗██║     ██╔════╝
#    ██████╔╝██║   ██║██║   ██║██║     ███████╗
#    ██╔═══╝ ██║   ██║██║   ██║██║     ╚════██║
#    ██║     ╚██████╔╝╚██████╔╝███████╗███████║
#    ╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚══════╝                                        

# Policies | Pools | VLAN
# range resource isn't a complete resource block --missing a key field therefore using the rest resource
vlanpools_map = {                       
    Dyn_VLAN-Pool-tftest       = {                             # map key (must match name variable)
        vlanpool_description      = ""                         # (optional)
        vlanpool_name             = "Dyn_VLAN-Pool-tftest"     # (required) name 1-64chars
        vlanpool_alloc_mode       = "dynamic"                  # (required) def: dynamic | static
    }
    InBand-Vlan-Pool-tftest       = {                          # map key (must match name variable)
        vlanpool_description      = ""                         # (optional)
        vlanpool_name             = "InBand-Vlan-Pool-tftest"  # (required) name 1-64chars
        vlanpool_alloc_mode       = "static"                   # (required) def: dynamic | static
    }
}

vlanranges_map = {                       
    vlanrange1 = {                                            # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "ACI Native VLAN 1"        # (optional)
        vlanrange_start_range    = "vlan-1"                   # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-1"                   # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange48-60 = {                                        # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-48"                  # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-60"                  # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange75-76 = {                                        # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "NX 03/04 Core CX"         # (optional)
        vlanrange_start_range    = "vlan-75"                  # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-76"                  # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange150-199 = {                                      # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "Dynamic Range"            # (optional)
        vlanrange_start_range    = "vlan-150"                 # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-199"                 # (required - must include "vlan-")
        vlanrange_alloc_mode     = "inherit"                  # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange220-260 = {                                      # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-220"                 # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-260"                 # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange998 = {                                          # map description key
        vlanpool_assc            = "InBand-Vlan-Pool-tftest"  # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-998"                 # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-998"                 # (required - must include "vlan-")
        vlanrange_alloc_mode     = "inherit"                  # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
     vlanrange1026-1200 = {                                   # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "Green Zone VLANS"         # (optional)
        vlanrange_start_range    = "vlan-1026"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-1200"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }   
    vlanrange1990 = {                                         # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-1990"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-1990"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange1968-1969 = {                                    # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "GRN L3 Vlans"             # (optional)
        vlanrange_start_range    = "vlan-1968"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-1969"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange2000-2252 = {                                    # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "Yellow Zone NonProd VLANs"# (optional)
        vlanrange_start_range    = "vlan-2000"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-2252"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange2253-2993 = {                                     # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"      # (required) vlan pool range is associated with
        vlanrange_description    = "remainder of YLLW ZN Vlans"# (optional)
        vlanrange_start_range    = "vlan-2253"                 # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-2993"                 # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                    # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                  # (optional) default external | internal
    }
    vlanrange2994-2995 = {                                    # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "ACI FW Test"              # (optional)
        vlanrange_start_range    = "vlan-2994"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-2995"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange3000-3966 = {                                    # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = "Red Zone Vlans"           # (optional)
        vlanrange_start_range    = "vlan-3000"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-3966"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange4066-4072 = {                                    # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-4066"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-4072"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
    vlanrange4074 = {                                         # map description key
        vlanpool_assc            = "Dyn_VLAN-Pool-tftest"     # (required) vlan pool range is associated with
        vlanrange_description    = ""                         # (optional)
        vlanrange_start_range    = "vlan-4074"                # (required - must include "vlan-")
        vlanrange_end_range      = "vlan-4074"                # (required - must include "vlan-")
        vlanrange_alloc_mode     = "static"                   # (optional) default inherit | static | dynamic
        vlanrange_role           = "external"                 # (optional) default external | internal
    }
}

## Test code -- opted for a better way (above)    
#vlanpoolrange_map = {                       
#   "Dyn_VLAN-Pool-tftest"         = {              # (required) name 1-64chars
#        vlanpoolrange_description = "yellow vlans" # (optional)
#        vlanpoolrange_from        = "45"           # start of range (number)
#        vlanpoolrange_to          = "60"           # end of range (number)
#        vlanpoolrange_allocmode   = "dynamic"      # (required) def: dynamic | static
#        }
#    }

#    ██████╗  ██████╗ ███╗   ███╗ █████╗ ██╗███╗   ██╗███████╗
#    ██╔══██╗██╔═══██╗████╗ ████║██╔══██╗██║████╗  ██║██╔════╝
#    ██║  ██║██║   ██║██╔████╔██║███████║██║██╔██╗ ██║███████╗
#    ██║  ██║██║   ██║██║╚██╔╝██║██╔══██║██║██║╚██╗██║╚════██║
#    ██████╔╝╚██████╔╝██║ ╚═╝ ██║██║  ██║██║██║ ╚████║███████║
#    ╚═════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝
                                                         

# Policies | Physical and External Domains | Pysical Domains
physdom_map = {                       
    "InBand-PhyDom-tftest" = {                                      # key = name (required) 1-64chars
        physdom_key                     = "InBand-PhyDom-tftest"    # key must match the map key
        physdom_name_alias              = ""                        # (optional)
        vlanpool_assc                   = "InBand-Vlan-Pool-tftest" # (optional) vlan pool association fvns:VlanInstP
        #physdom_rsinfra_vlan_ns_def    = ""                        # (optional) Relation to fvns:AlnstP
        #physdom_rsinfra_vip_addr       = ""                        # (optional) Relation to fvns:AddrInst
        #physdom_rsinfra_extnw $1600    = ""                        # (optional) Relation to infra:AccGrp
        #physdom_rsinfra_vxlan_def      = ""                        # (optional) Relation to fvns:Alnstp
    }
    "NonProd_Compute-PhyDom-tftest" = {                             # key = name (required) 1-64chars
        physdom_key                     = "NonProd_Compute-PhyDom-tftest"    # key must match the map key
        physdom_name_alias              = ""                        # (optional)
        vlanpool_assc                   = "Dyn_VLAN-Pool-tftest"    # (optional) vlan pool association fvns:VlanInstP
        #physdom_rsinfra_vlan_ns_def    = ""                        # (optional) Relation to fvns:AlnstP
        #physdom_rsinfra_vip_addr       = ""                        # (optional) Relation to fvns:AddrInst
        #physdom_rsinfra_extnw $1600    = ""                        # (optional) Relation to infra:AccGrp
        #physdom_rsinfra_vxlan_def      = ""                        # (optional) Relation to fvns:Alnstp
    }
    "Prod_Compute-PhyDom-tftest" = {                                # key = name (required) 1-64chars
        physdom_key                     = "Prod_Compute-PhyDom-tftest"    # key must match the map key
        physdom_name_alias              = ""                        # (optional)
        vlanpool_assc                   = "Dyn_VLAN-Pool-tftest"    # (optional) vlan pool association fvns:VlanInstP
        #physdom_rsinfra_vlan_ns_def    = ""                        # (optional) Relation to fvns:AlnstP
        #physdom_rsinfra_vip_addr       = ""                        # (optional) Relation to fvns:AddrInst
        #physdom_rsinfra_extnw $1600    = ""                        # (optional) Relation to infra:AccGrp
        #physdom_rsinfra_vxlan_def      = ""                        # (optional) Relation to fvns:Alnstp
    }
    "Prod_Network-PhyDom-tftest" = {                                # key = name (required) 1-64chars
        physdom_key                     = "Prod_Network-PhyDom-tftest"    # key must match the map key
        physdom_name_alias              = ""                        # (optional)
        vlanpool_assc                   = "Dyn_VLAN-Pool-tftest"    # (optional) vlan pool association fvns:VlanInstP
        #physdom_rsinfra_vlan_ns_def    = ""                        # (optional) Relation to fvns:AlnstP
        #physdom_rsinfra_vip_addr       = ""                        # (optional) Relation to fvns:AddrInst
        #physdom_rsinfra_extnw $1600    = ""                        # (optional) Relation to infra:AccGrp
        #physdom_rsinfra_vxlan_def      = ""                        # (optional) Relation to fvns:Alnstp
    }
}

# Policies | Physical and External Domains | L3 Domains
l3dom_map = {                       
    "Prod_Network-L3Dom-tftest" = {                                 # key = name (required) 1-64chars
        l3dom_key                   = "Prod_Network-L3Dom-tftest"   # key must match the map key
        l3dom_name_alias            = ""                            # (optional)
        vlanpool_assc               = "Dyn_VLAN-Pool-tftest"        # (optional) vlan pool association fvns:VlanInstP
        #l3dom_rsinfra_vlan_ns_def  = ""                            # (optional) Relation to fvns:AlnstP
        #l3dom_rsinfra_vip_addr     = ""                            # (optional) Relation to fvns:AddrInst
        #l3dom_rsinfra_extnw $1600  = ""                            # (optional) Relation to infra:AccGrp
        #l3dom_rsinfra_vxlan_def    = ""                            # (optional) Relation to fvns:Alnstp
    }
}