# Complete example 

module "spinnaker-managed-role" {
  source  = "tf-mod/spinnaker-managed-role/aws"
  version = "1.0.0"

  desc             = var.desc
  trusted_role_arn = var.trusted_role_arn
}
