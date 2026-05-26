variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access HTTP/HTTPS"
  type        = string
  default     = "0.0.0.0/0"
}
