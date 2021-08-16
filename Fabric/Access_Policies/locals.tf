/*

    author: Rob Wieters

    usage:

      A local value assigns a name to an expression, so you can use it multiple times within a 
      module without repeating it.

      In this file, three variables are defined, to identify the engineer initiating the workflow,
      a reference to the service request ticket (every change in a netdevops env should have a change#),
      and a timestamp to inform others when the change was applied (this in the form of a function).

      You can also define locals in the main module if it is relevant to do so for a particular resource or
      data block (as in the /Access_Policies/main.tf)

    references:
      - https://www.terraform.io/docs/configuration/locals.html

*/

locals {
  # These locals were used to "taint" an object to create a "last-updated" entry in the description or preferably 
  # the owner_tag fields to provide insight as to who made the change, the CC#, and when.
  #
  # However, while the updates worked, they actually caused every field that contained the interpolation string to update
  # during every run regardless if the the field was actually updated or not. Needs more work-perhaps using conditionals.
  # example interpolation:
  #
  #   Field = "${each.value.lldp_description}--${local.service_request} by ${local.initiator} on ${formatdate("DD MMM YYYY hh:mm:ss ZZZ", timestamp())}"
  #
  initiator = "RHW"
  service_request = "CHG000000"
  time_stamp = formatdate("DD MMM YYYY hh:mm:ss ZZZ", timestamp())
}