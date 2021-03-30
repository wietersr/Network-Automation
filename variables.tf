# map variable declaration for VRF
variable "ylw_vrf_map" {type = list(object({vrf = string}))}

# map variable declaration for BD/Subnet
variable "bts_nonprod_bd_map" {type = map(object({bd_subnet = string}))}

# map variable declaration for AP

# map variable declaration for EPG
