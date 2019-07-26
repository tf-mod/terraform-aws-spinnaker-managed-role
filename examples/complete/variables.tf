
variable "aws_account_id" {
  description = "The aws account id for the tf backend creation (e.g. 857026751867)"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "default"
}

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
