
# trusted roles
variable "trusted_role_arn" {
  description = "A list of full arn of iam roles of spinnaker cluster"
  default     = []
}

# description
variable "desc" {
  description = "The purpose of your aws account"
  default     = ""
}