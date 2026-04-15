module "vpc" {
  source              = "../../modules/vpc"
  name_prefix         = local.name_prefix
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  public_subnet_azs   = var.public_subnet_azs
  tags                = local.tags
}

module "security_groups" {
  source            = "../../modules/security-groups"
  name_prefix       = local.name_prefix
  vpc_id            = module.vpc.vpc_id
  dev_ingress_cidrs = var.dev_ingress_cidrs
  tags              = local.tags
}

module "dev_ec2" {
  source            = "../../modules/dev-ec2"
  name_prefix       = local.name_prefix
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security_groups.dev_ec2_security_group_id
  instance_type     = var.instance_type
  tags              = local.tags
}
