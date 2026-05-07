output "environment" { value = var.environment }
output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "instance_id" { value = module.dev_ec2.instance_id }
output "public_ip" { value = module.dev_ec2.public_ip }
output "ecr_repository_arns" {
  value = { for k, v in aws_ecr_repository.this : k => v.arn }
}
output "ecr_repository_urls" {
  value = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}
output "github_actions_user_arn" { value = aws_iam_user.github_actions.arn }
output "chefmind_backend_repository_url" { value = aws_ecr_repository.this["chefmind-backend"].repository_url }
output "chefmind_web_repository_url" { value = aws_ecr_repository.this["chefmind-web"].repository_url }
output "chefmind_litellm_repository_url" { value = aws_ecr_repository.this["chefmind-litellm"].repository_url }
