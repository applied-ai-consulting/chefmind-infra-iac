variable "name_prefix" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidrs" { type = list(string) }
variable "public_subnet_azs" { type = list(string) }
variable "tags" { type = map(string) }
