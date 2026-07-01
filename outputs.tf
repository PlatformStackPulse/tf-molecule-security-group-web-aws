output "id" {
  description = "Disambiguated ID (tf-label) for the web security group tier."
  value       = module.this.id
}

output "security_group_id" {
  description = "ID of the web security group"
  value       = module.security_group.id
}

output "security_group_arn" {
  description = "ARN of the web security group"
  value       = module.security_group.arn
}
