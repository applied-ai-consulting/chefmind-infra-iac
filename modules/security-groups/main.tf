resource "aws_security_group" "dev_ec2" {
  name        = "${var.name_prefix}-dev-ec2-sg"
  description = "Security group for dev EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allowed ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.dev_ingress_cidrs
  }

  ingress {
    description = "Allowed ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.dev_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-dev-ec2-sg" })
}
