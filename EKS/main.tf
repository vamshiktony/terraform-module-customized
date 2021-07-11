provider "aws" {
  region = "ap-south-1"
}
   
module "vpc" {
  source = "./vpc"
#  public_subnet_cidr_block = "var.public_subnet_cidr_block"
  cidr_block                =   var.cidr_block
  public_subnet_cidr_block  =   var.public_subnet_cidr_block
  public1_subnet_cidr_block =   var.public1_subnet_cidr_block
  av_zone1                  =   var.av_zone1
  av_zone2                  =   var.av_zone2
  cluster_name              =   var.cluster_name
}

########################### creating a EKS cluster in aws ###########################################

module "eks" {
  source = "./eks_cluster"
  cluster_name              =    var.cluster_name
  subnet1                   =   "${module.vpc.subnet_id}"
  subnet2                   =   "${module.vpc.subnet2_id}"
  security_group            =   "${module.vpc.securitygroup_id}"

}


############################# creating eks workernode_grouup for EKS cluster ###################################
module "eks_workernode" {
  source = "./eks_workernodes"
  cluster_name              =   "${module.eks.cluster_name}"
  node_group_name           =   var.node_group_name
  instance_type             =   var.instance_type
  subnet1                   =   "${module.vpc.subnet_id}"
  subnet2                   =   "${module.vpc.subnet2_id}"
  key_name                  =    var.key_name
  security_group            =   "${module.vpc.securitygroup_id}"
}





