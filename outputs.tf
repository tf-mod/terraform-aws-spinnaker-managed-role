
output "role_id" {
  value       = aws_iam_role.spinnaker-managed.id
  description = "The generated arn of spinnaker managed role"
}