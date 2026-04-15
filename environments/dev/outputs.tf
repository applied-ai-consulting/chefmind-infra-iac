output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "instance_id" { value = module.dev_ec2.instance_id }
output "public_ip" { value = module.dev_ec2.public_ip }
