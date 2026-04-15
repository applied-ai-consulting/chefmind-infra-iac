#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-us-west-2}"
PROJECT_TAG="chef-mind"
aws sts get-caller-identity
aws ec2 describe-vpcs --region "$REGION" --filters Name=tag:Project,Values="$PROJECT_TAG"
aws ec2 describe-instances --region "$REGION" --filters Name=tag:Project,Values="$PROJECT_TAG"
aws ec2 describe-addresses --region "$REGION" --filters Name=tag:Project,Values="$PROJECT_TAG"
