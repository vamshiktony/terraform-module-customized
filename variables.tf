variable "aws_region_name"  { default = "ap-south-1" }
variable "cidr_block"    { default = "11.0.0.0/16" }
variable "public_subnet_cidr_block"  { default = "11.0.0.0/24" }
variable "public1_subnet_cidr_block"  { default = "11.0.2.0/24"}
variable "av_zone1" { default = "ap-south-1a" }
variable "av_zone2" { default = "ap-south-1b" }


##### instance settings #######################################
variable "ami_instance" { default = "ami-011c99152163a87ae" }
variable "instance_type" { default = "t2.micro" }
variable "public_subnet_id" { default = "subnet-044ef28635cf33c96" }

########## albloadbalancer_creation ##################

variable "albloadbalancer_name" { default = "harshad" }
variable "securitygroup_id"     { default = "sg-00a45dc0e7c4146aa" }
variable "subnet1"   { default = "subnet-168aff5a" }
variable "subnet2"   { default = "subnet-b15ee1ca" }
variable "vpc_id"    { default = "vpc-a50b15cd"    }

variable "instance_id" { default = "i-0585f4b696c542d3e" }
variable "instance2_id" { default = "i-0585f4b696c542d3e" }


############ autoscaling group adding to above loadbalancer #######################
variable "security_group_id"     { default = "sg-00a45dc0e7c4146aa" }
variable "subnet1a"  { default = "subnet-168aff5a" }
variable "subnet2b"  { default = "subnet-b15ee1ca" }
variable "name"     { default = "harshad" }
variable "albtargetgroup_arn" { default = "harshad" }
