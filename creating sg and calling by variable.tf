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