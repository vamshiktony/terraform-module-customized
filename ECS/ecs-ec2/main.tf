provider "aws" {
  region = "ap-south-1"
}


#######################################################################################################################
##############creating ECS cluster in above vpc and subnets using terraform#######################################33


data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}




resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}





resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ecs_agent.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}








#resource "aws_iam_role_policy_attachment" "ecs_agent" {
#  role       = "aws_iam_role.ecs_agent.name"
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#}


#resource "aws_iam_role_policy_attachment" "AmazonEcSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#  role       = aws_iam_role.ecs_agent.name
#}




resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = "${aws_iam_role.ecs_agent.name}"
}






##############################################################################################
#launch configuration ###########################################

resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = "ami-087632d3a5a48acf4"
#    iam_instance_profile = "aws_iam_instance_profile.ecs_agent.arn"
    iam_instance_profile = "${aws_iam_instance_profile.ecs_agent.name}"
    security_groups      = [ var.securitygroup_cluster ]
#    security_group_ids =  [ var.securitygroup_cluster ]
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=harshad >> /etc/ecs/ecs.config"
    instance_type        = "t2.micro"


root_block_device {
           delete_on_termination = true
           encrypted             = true
  #         iops                  = (known after apply)
           volume_size           = 30
           volume_type           = "gp2"
        }

}



resource "aws_autoscaling_group" "ecs_autoscaling_group" {
    name                      = "asg"
    vpc_zone_identifier       = [ var.subnet_first, var.subnet_second ]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "EC2"
}



resource "aws_ecs_cluster" "new" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}




resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "second"
      image     = "nginx"
      cpu       = 512
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

}


#################################################################################################################
#creating a service using above task defination without a  loadbalancer ##############################


###################################################################################################
#resource "aws_ecs_service" "worker" {
#  name            = "service"
#  cluster         = aws_ecs_cluster.new.id
#  task_definition = aws_ecs_task_definition.service.arn
#  desired_count   = 2
#}
#####################################################################################################


#creating a service using above task definetion with a loadbalancer#################################
resource "aws_ecs_service" "my_service" {
  name            = "my_service"
  cluster         = aws_ecs_cluster.new.id
#  launch_type                        = (known after apply)
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = 1
#  iam_role        = aws_iam_role.foo.arn
#  depends_on      = [aws_iam_role_policy.foo]

#  ordered_placement_strategy {
#    type  = "binpack"
#    field = "cpu"
#  }

  load_balancer {
    target_group_arn = var.targetgroup_arn
    container_name   = "second"
    container_port   = 80
  }

 # placement_constraints {
 #   type       = "memberOf"
 #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
 # }
}

