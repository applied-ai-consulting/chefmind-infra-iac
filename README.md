# chefmind-infra-iac

Terraform infrastructure for Chef Mind across AWS environments:
- dev
- staging (qa)
- prod

## Current status
- **dev** implemented and applied
- **staging** scaffolded
- **prod** scaffolded

## Layout
- `modules/`: reusable Terraform modules
- `environments/`: environment root modules
- `scripts/`: helper scripts for backend bootstrap, state discovery, and planning

## Dev backend
- S3 bucket: `chef-mind-dev-tfstate-897708493501-us-west-2`
- DynamoDB lock table: `chef-mind-dev-tf-lock`
- State key: `dev/terraform.tfstate`

## Usage
```bash
cd environments/dev
terraform init -reconfigure -backend-config=backend.hcl
terraform plan
```
