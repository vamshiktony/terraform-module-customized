provider "aws" {
   region= "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = var.ami_instance
  instance_type = var.instance_type
  subnet_id  = var.public_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  tags = {
    Name = "HelloWorld"
  }
 # vpc_security_group_ids  = { "var.securit_ygroup.id" }
}


output instance1_id {
   value = "${aws_instance.web.id}"
}
