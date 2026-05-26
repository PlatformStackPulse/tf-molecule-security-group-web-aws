module "security_group" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-security-group-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = var.name
  stage     = var.stage
  tags      = var.tags

  vpc_id      = var.vpc_id
  description = "Web tier security group - HTTP/HTTPS ingress"
}

module "ingress_http" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-security-group-rule-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = "${var.name}-http-in"
  stage     = var.stage
  tags      = var.tags

  security_group_id = module.security_group.id
  rule_type         = "ingress"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_cidr
  description       = "HTTP from allowed CIDR"
}

module "ingress_https" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-security-group-rule-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = "${var.name}-https-in"
  stage     = var.stage
  tags      = var.tags

  security_group_id = module.security_group.id
  rule_type         = "ingress"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = var.allowed_cidr
  description       = "HTTPS from allowed CIDR"
}

module "egress_all" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-security-group-rule-aws.git?ref=v1.1.0"

  enabled   = module.this.enabled
  namespace = var.namespace
  name      = "${var.name}-all-out"
  stage     = var.stage
  tags      = var.tags

  security_group_id = module.security_group.id
  rule_type         = "egress"
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "All outbound traffic"
}
