provider "aws" {
   region= "ap-south-1"
}

module "vpc" {
  source = "./vpc"
#  public_subnet_cidr_block = "var.public_subnet_cidr_block"
  cidr_block               = var.cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
  public1_subnet_cidr_block = var.public1_subnet_cidr_block
  av_zone1                  = var.av_zone1
  av_zone2                  = var.av_zone2
}


module "alb" {
  source = "./alb-balancer"
  albloadbalancer_name = var.albloadbalancer_name
  securitygroup_id   =  "${module.vpc.securitygroup_id}"
  subnet1 = "${module.vpc.subnet_id}"  
  subnet2 = "${module.vpc.subnet2_id}"  
  vpc_id  = "${module.vpc.vpc_id}" 

}

module "ecs" {
  source = "./ecs-ec2"
  cluster_name = var.cluster_name
  securitygroup_cluster = "${module.vpc.securitygroup_id}"
  subnet_first         = "${module.vpc.subnet_id}"
  subnet_second        =  "${module.vpc.subnet2_id}"
  targetgroup_arn      =  "${module.alb.targetgroup_arn}"
}





