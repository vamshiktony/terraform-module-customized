###############################################autoscaling if you have anydoubts please look into this document ########################
##https://stackoverflow.com/questions/62558731/attaching-application-load-balancer-to-auto-scaling-group-in-terraform-gives



resource "aws_launch_configuration" "example" {
  image_id               = "ami-0c1a7f89451184c8b"
  instance_type          = "t2.micro"
  security_groups        = [ var.security_group_id]
  name                        = var.name
  key_name               =  "ramcharan"
  user_data = <<-EOF
              #!/bin/bash
              systemctl status nginx
              if [ $? -ne 0 ];
              then
                 sudo apt update -y
                 sudo apt install nginx -y
              else
                 echo "nginx is already installed"
              echo "Hello, World" > index.html
              EOF
  lifecycle {
    create_before_destroy = true
  }
}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  depends_on =           [aws_launch_configuration.example]
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier       = [ var.subnet1a, var.subnet2b ]
#  availability_zones = ["${data.aws_availability_zones.all.names}"]
  desired_capacity  = 2
  min_size = 2
  max_size = 2
#  load_balancers =   aws_elb.example.name  #                        ["${aws_elb.example.name}"]
#  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}




resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = aws_autoscaling_group.example.id                  ###aws_autoscaling_group.MyWPReaderNodesASGroup.id
  alb_target_group_arn = var.albtargetgroup_arn          ##targetgroup_arn
}
