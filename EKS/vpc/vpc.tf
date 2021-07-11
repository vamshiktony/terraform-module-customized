resource "aws_vpc" "ram" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.ram.id
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ram.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_subnet" "public" {
 # count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.ram.id
  cidr_block              = var.public_subnet_cidr_block #"10.0.1.0/24"
  availability_zone       = var.av_zone1  #"ap-south-1a"
  map_public_ip_on_launch = true
    tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"      =  1
    "kubernetes.io/role/elb"               =  1
  }
}

resource "aws_subnet" "public1" {
 # count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.ram.id
  cidr_block              = var.public1_subnet_cidr_block   #"10.0.2.0/24"
  availability_zone       = var.av_zone2 #"ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb"              =  1
    "kubernetes.io/role/internal-elb"     =  1
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}



resource "aws_route_table_association" "public" {
 # count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public1" {
 # count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "ssh-allowed" {
    vpc_id =  aws_vpc.ram.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

}



output "vpc_id" {
  value = aws_vpc.ram.id
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "subnet2_id" {
  value = "${aws_subnet.public1.id}"
}

output "securitygroup_id" {
  value = "${aws_security_group.ssh-allowed.id}"
}

