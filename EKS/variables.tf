########################33 creating vpc and subnets for eks cluster #################################
variable "aws_region_name"  { default = "ap-south-1" }
variable "cidr_block"    { default = "11.0.0.0/16" }
variable "public_subnet_cidr_block"  { default = "11.0.0.0/24" }
variable "public1_subnet_cidr_block"  { default = "11.0.2.0/24"}
variable "av_zone1" { default = "ap-south-1a" }
variable "av_zone2" { default = "ap-south-1b" }

############################3 creating a EKS cluster ######################################################
variable "cluster_name"  {default = "harshad"}
variable "subnet1" { default = "subnet-168aff5a" }
variable "subnet2" { default = "subnet-b76364df" }
variable "security_group" { default = "sg-08c51f47131704c99" }


################################# creating eks workernode_group for EKS cluster ###############################
variable  "node_group_name" { default = "harshad" }
variable  "instance_type"   { default = "t2.medium" }
#variable  "subnet1"         { default = "subnet-168aff5a" }
#variable  "subnet2"         { default = "subnet-b76364df" }
variable  "key_name"        { default = "ramcharan" }
