variable "aws_region_name"  { default = "ap-south-1" }
variable "cidr_block"    { default = "10.0.0.0/16" }
variable "public_subnet_cidr_block"  { default = "10.0.0.0/24" }
variable "public1_subnet_cidr_block"  { default = "10.0.2.0/24"}
variable  "av_zone1"   { default = "ap-south-1a" }
variable  "av_zone2"   { default = "ap-south-1b" }

#variable "project_name" {}
#variable "environment_name" {}
#variable "vpc_id" {}
#variable "cluster_name" {}
#variable "public_subnets"  { type = list(string) }
#variable "private_subnets"  { type = list(string) }
