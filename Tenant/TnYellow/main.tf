#########################################################################
# Network Centric ACI Deployment via Terraform
#########################################################################

# One Tenant
resource "aci_tenant" "tenantLocalName" {
  name = "YLW"
  name_alias = "Yellow"
}

# Multiple VRFs per Tenant
resource "aci_vrf" "vrfLocalName" {
    for_each = toset(var.ylw_vrf_set)
    
    name = each.value
    tenant_dn = aci_tenant.tenantLocalName.id
}

# Multiple Bridge Domains (VLAN = BD = EPG)
resource "aci_bridge_domain" "bdLocalName" {
  for_each = var.bd_map
  
  name = each.key
  tenant_dn = aci_tenant.tenantLocalName.id
  relation_fv_rs_ctx = aci_vrf.vrfLocalName[each.value.vrf].id
}

# Each Bridge Domain includes a subnet with public scope
resource "aci_subnet" "subnetAppLocalName" {
  for_each = var.bd_map
  
  parent_dn = aci_bridge_domain.bdLocalName[each.key].id
  ip = each.value.subnet
  scope = [ "public" ]
}

# Multiple Application Profiles (each associated to their prefixed EPG)
resource "aci_application_profile" "apLocalName" {
  for_each = var.ap_set
  
  tenant_dn = aci_tenant.tenantLocalName.id
  name = each.value
}

# Multiple Application EPGs (each associated to their prefixed AP
# and appending their respective subnets as suffix)
resource "aci_application_epg" "epgLocalName" {
  for_each = var.epg_map

  name = each.key
  name_alias = each.value.name_alias
  application_profile_dn = aci_application_profile.apLocalName[each.value.ap].id
  relation_fv_rs_bd = aci_bridge_domain.bdLocalName[each.value.bd].id
}

# Add physDomain to fabric before associations can occur
# This should actually be installed in the fabric policies folderS
resource "aci_physical_domain" "physLocalName" {
  name = "Prod_Network-PhyDom"
}

# Each EPG is mapped to a physical domain
resource "aci_epg_to_domain" "epgToDomainLocalName" {
  for_each = var.epg_map

  application_epg_dn    = aci_application_epg.epgLocalName[each.key].id
  tdn                   = each.value.physdomain_dn
}

# # Each EPG is mapped to a Static Path Binding (WIP)
# resource "aci_epg_to_static_path" "epgToStaticPathLocalName" {
#   for_each = var.epg_map
  
#   application_epg_dn  = aci_application_epg.epgLocalName[each.key].id
#   tdn  = "topology/pod-1/protpaths-111-112/pathep-[NX01_02_Blk_vpc-intPG]"
#   encap  = each.value.vlan
# #  mode  = "regular"
# }