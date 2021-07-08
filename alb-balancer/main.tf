 resource "aws_alb_listener" "listener_http" {
#      + arn               = (known after apply)
#      + id                = (known after apply)
       load_balancer_arn = aws_lb.alb.arn
       port              = 80
       protocol          = "HTTP"
#      + ssl_policy        = (known after apply)

       default_action {
#          + order            = (known after apply)
           target_group_arn = aws_lb_target_group.my-group.arn
           type             = "forward"
        }
    }

  # aws_alb_target_group_attachment.ec2_adding will be created
   resource "aws_alb_target_group_attachment" "first_instance_adding" {
  #    + id               = (known after apply)
       target_group_arn = aws_lb_target_group.my-group.arn
       target_id        = var.instance_id
    }

   resource "aws_alb_target_group_attachment" "second_instance_adding" {
  ##    + id               = (known after apply)
       target_group_arn = aws_lb_target_group.my-group.arn
       target_id        = var.instance2_id
    }
















resource "aws_lb" "alb" {
       enable_http2               = true
       internal                   = false
       ip_address_type            = "ipv4"
       load_balancer_type         = "application"
       name                       = var.albloadbalancer_name
       security_groups            = [
           var.securitygroup_id
        ]
#       subnets                    = [
#           "subnet-168aff5a",
#           "subnet-b15ee1ca",
#           "subnet-b76364df",
#        ]
       tags                       = {
           "Name" = "terraform-example-alb"
        }
#       vpc_id                     = "vpc-a50b15cd"
     #  zone_id                    = (known after apply)

       subnet_mapping {
      #    + allocation_id        = (known after apply)
      #    + ipv6_address         = (known after apply)
      #    + outpost_id           = (known after apply)
      #    + private_ipv4_address = (known after apply)
           subnet_id            =   var.subnet1 
        }
       subnet_mapping {
           subnet_id            =   var.subnet2
        }

#       subnet_mapping {
#           subnet_id            =   "subnet-b76364df"
#        }

    }

resource "aws_lb_target_group" "my-group" {
       name                               = "mytargetset"
       port                               = 80
     # + preserve_client_ip                 = (known after apply)
       protocol                           = "HTTP"
     # + protocol_version                   = (known after apply)
     # + proxy_protocol_v2                  = false
     # + slow_start                         = 0
       target_type                        = "instance"
       vpc_id                             = var.vpc_id

       health_check {
           enabled             = true
           healthy_threshold   = 5
           interval            = 10
         # + matcher             = (known after apply)
           path                = "/"
           port                = "traffic-port"
           protocol            = "HTTP"
           timeout             = 5
           unhealthy_threshold = 2
        }

     # + stickiness {
      #    + cookie_duration = (known after apply)
      #    + enabled         = (known after apply)
      #    + type            = (known after apply)
       # }
    }


output "targetgroup_arn" {
  value = "${aws_lb_target_group.my-group.arn}"
}
