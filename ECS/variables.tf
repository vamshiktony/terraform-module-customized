variable "aws_region_name"  { default = "ap-south-1" }
variable "cidr_block"    { default = "11.0.0.0/16" }
variable "public_subnet_cidr_block"  { default = "11.0.0.0/24" }
variable "public1_subnet_cidr_block"  { default = "11.0.2.0/24"}
variable "av_zone1" { default = "ap-south-1a" }
variable "av_zone2" { default = "ap-south-1b" }

########## albloadbalancer_creation ##################

variable "albloadbalancer_name" { default = "harshad" }
variable "securitygroup_id"     { default = "sg-00a45dc0e7c4146aa" }
variable "subnet1"   { default = "subnet-168aff5a" }
variable "subnet2"   { default = "subnet-b15ee1ca" }
variable "vpc_id"    { default = "vpc-a50b15cd"    }

############ autoscaling group adding to above loadbalancer #######################
variable "cluster_name" { default = "harshad" }
variable "securitygroup_cluster" { default = "sg-08c51f47131704c99" }
variable "subnet_first"          { default = "subnet-b15ee1ca" }
variable "subnet_second"         { default = "subnet-168aff5a" }
variable "targetgroup_arn"       { default = "arn"  }
