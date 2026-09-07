provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2"{
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    key_name = "matin"

    tags = {
        Name = "practice"
    }
}


#------------------------------------------------------------------------------------------------------

# creating sg and calling by variable

provider "aws" {
    region = var.region
}

resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.my-sg.id ]

    tags = {
        Name = "pratice"
    }
}


resource "aws_security_group" "my-sg" {
    name = "my-sg"
    vpc_id = var.vpc_id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }  

}

variable "region" {
    default = "ap-south-1"
}

variable "ami_id" {
    default = "ami-01a00762f46d584a1" 
}

variable "instance_type" {
    default = "t3.micro"
}

variable "vpc_id" {
    default = "vpc-033195fb7d55da4ac"
  
}

# hw 
## write user data through terraform script

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "ec2" {
    ami= "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    key_name = "matin"

    user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install nginx -y
                systemctl start nginx
                systemctl enable nginx
                EOF

    tags = {
        Name = "practice"
    }

}

# -----------------------------------------------------------------------------------------------------------------------------

# launch template 2
# asg 2
# tg 2
# lb 1
# listener 1
# rule 1

# also create alarm , asg policy 

provider "aws" {
  region = "ap-south-1"
}

resource "aws_launch_template" "home-temp" {
  name = "home-temp"
  image_id = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  key_name = "matin"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    echo "<h1> WELCOME TO HOME PAGE </h1>" > /var/www/html/index.html
    systemctl start nginx
    systemctl enable nginx
EOF
  )
}

resource "aws_launch_template" "cloth-temp" {
  name = "cloth-temp"
  image_id = "ami-01a00762f46d584a1"
  instance_type = "t3.micro"
  key_name = "matin"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt update -y
    apt install nginx -y
    mkdir -p /var/www/html/cloth
    echo "<h1> SALE! SALE!! SALE!!! </h1>" > /var/www/html/cloth/index.html
    systemctl start nginx
    systemctl enable nginx
EOF
  )
}

resource "aws_autoscaling_group" "home-asg" {
    name = "home-asg"
    availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    max_size = 1
    min_size = 1
    desired_capacity = 1

    launch_template {
      id = aws_launch_template.home-temp.id
      version = "$Latest"
    }
}

resource "aws_autoscaling_group" "cloth-asg" {
    name = "cloth-asg"
    availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    max_size = 1
    min_size = 1
    desired_capacity = 1

    launch_template {
      id = aws_launch_template.cloth-temp.id
      version = "$Latest"
    }
}

resource "aws_cloudwatch_metric_alarm" "home-alarm" {
    alarm_description = " this is scale down alarm"
    alarm_name = "home-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    evaluation_periods = 5
    period = 60
    statistic = "Average"
    threshold = 25

    dimensions = {
        autoscaling_group_name = aws_autoscaling_group.home-asg.name
    }

    alarm_actions = [
        aws_autoscaling_policy.home-asg.arn
    ]
}

resource "aws_cloudwatch_metric_alarm" "cloth-alarm" {
    alarm_description = " this is scale down alarm for cloth"
    alarm_name = "cloth-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    evaluation_periods = 5
    period = 60
    statistic = "Average"
    threshold = 25

    dimensions = {
        autoscaling_group_name = aws_autoscaling_group.cloth-asg.name
    }

    alarm_actions = [
        aws_autoscaling_policy.cloth-asg.arn
    ]
}


resource "aws_autoscaling_policy" "home-asg" {
    name = " scale_down"
    autoscaling_group_name = aws_autoscaling_group.home-asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown = 120
}


resource "aws_autoscaling_policy" "cloth-asg" {
    name = " scale_down"
    autoscaling_group_name = aws_autoscaling_group.cloth-asg.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown = 120  
}

resource "aws_lb_target_group" "home-tg" {
    name = "home-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-033195fb7d55da4ac"
}

resource "aws_lb_target_group" "cloth-tg" {
    name = "cloth-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-033195fb7d55da4ac"
}

resource "aws_autoscaling_attachment" "home-attach" {
    autoscaling_group_name = aws_autoscaling_group.home-asg.id
    lb_target_group_arn = aws_lb_target_group.home-tg.arn
}

resource "aws_autoscaling_attachment" "cloth-attach" {
    autoscaling_group_name = aws_autoscaling_group.cloth-asg.id
    lb_target_group_arn = aws_lb_target_group.cloth-tg.arn
}

resource "aws_lb" "alb" {
    name = "alb"
    internal = false
    load_balancer_type = "application"
    security_groups = ["sg-08ad0ebaeba9ca245"]
    subnets = ["subnet-09cbede1a37a36b6e", "subnet-0c2f3577584c9ce23", "subnet-0c622c07a6caad284"]
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.home-tg.arn
    }
}

resource "aws_lb_listener_rule" "rule" {
    listener_arn = aws_lb_listener.listener.arn
    priority = 1

    action {
      type = "forward"
      target_group_arn = aws_lb_target_group.cloth-tg.arn
    }

    condition {
      path_pattern {
        values = ["/cloth/*"]
      }
    } 
}