# Deploy ACI using Terraform
Resource for sharing the Network Automation helps, cheats, and other morsels

## Folder Structures  
- Minimize exposure to code that doesn't need changing  
-- Separate the different parts of the main module (root main.tf) so that provider version, provider url/creds, and statefile config, etc are all in separate files. Terraform assembles all the tf, var, and tfvars file components into one logical set at run-time.
- Each Tenant's config to reside in its own subdirectory of "Tenant"
- Fabric Config to reside in its own directory of "Fabric_Policies"
- Use shared storage to store the tfstate when multiple users will access/share the terraform config and ensure the statefile can be locked while in use and versioned. This config uses an S3 bucket and DynamoDB table in AWS.
## Fabric Configuration (TBD)
## Tenant Configuration
##### Note: the actual config may be slightly different than the below content  

#### ***Multiple VRF's per Tenant:***
>NonProd-VRF  
>BTS_NonProd-VRF  
>BTS_Prod-VRF  
>SCS_Prod-VRF
----------------------------------------------
#### ***Multiple Bridge Domains (VLAN = BD = EPG)***
##### Each Bridge Domain includes a subnet with public scope
>BTS_NonProd_Database_Svc (subnet 192.168.1.1/24)  
>BTS_NonProd_FnP_Svc (subnet 192.168.2.1/24)  
>BTS_Prod_Database_Svc (subnet 192.168.3.1/24)  
>BTS_Prod_FnP_Svc (subnet 192.168.4.1/24)  
>SCS_Prod_Database_Svc (subnet 192.168.5.1/24)  
>SCS_Prod_FnP_Svc (subnet 192.168.6.1/24)  
----------------------------------------------
#### ***Multiple Application Profiles (each associated to their prefixed EPG)***
----------------------------------------------
>NonProd-AP  
>BTS_Prod-AP  
>SCS_Prod-AP
----------------------------------------------
#### ***Multiple Application EPG's*** 
##### ***(Each EPG associated to its prefixed AP and appending their respective subnets as suffix)***
>BTS_NonProd_Database_Svc_192.168.1.0  
>BTS_NonProd_FnP_Svc_192.168.2.0  
>BTS_Prod_Database_Svc_192.168.3.0  
>BTS_Prod_FnP_Svc_192.168.4.0  
>SCS_Prod_Database_Svc_192.168.5.0  
>SCS_Prod_FnP_Svc_192.168.6.0,
---------------------------------------------
#### ***Each EPG is mapped to a physical domain:***  
>Prod_Network-PhyDom
----------------------------------------------
#### ***Each EPG mapped to Static Path Binding***
##### ***(pod: 1, switch1: 201, switch2: 202, vpc)*** NX01_02_Blk_vpc-intPG, encap: [vlanID]
----------------------------------------------
#### ***L3Out: each BD is associated to "NonProd" L3Out***
>TBD
----------------------------------------------  

##### Much Appreciation to Vasily Propakov for his help in getting me started on Network Centric tf deployment and for his new youtube channel: [Late Night Engineering](https://www.youtube.com/channel/UCbnGKv4mCYG1rblQ5o9MWRQ).

