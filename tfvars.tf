# mkdir ec2-multi-env 
# cd ec2-multi-env

# touch main.tf variables.tf

# mkdir env

# touch env/dev.tfvars env/stage.tfvars env/prod.tfvars


# mai.tf 

provider "aws" {
    region = var.region
}

resource "aws_instance" "my-ec2" {
    ami = var.ami_id
    instance_type = var.instance_type

    tags = {
        Name = "ec2-${var.environment}"
        Env = var.environment
    }
}

#--------------------------------------------------------------------

# varibles.tf 

variable "instance_type" {
    description = "EC2 instance type"
    type = string
}

variable "aws_region" {
    description = "AWS region"
    type = string
}

variable "ami_id" {
    description = "AMI ID"
    type = string
}

variable "environment" {
    description = "Environment name (dev, stage, prof)"
    type = string
}

# ---------------------------------------------------------------------------------------------------
# env/dev.tfvars

environment = "dev"
aws_region = "ap-south-1"
ami_id = "ami-01a00762f46d584a1"
instance_type = "t3.micro"

# ---------------------------------------------------------------------------------------------------
# env/stage.tfvars

environment = "stage"
aws_region = "ap-south-1"
ami_id = "ami-01a00762f46d584a1"
instance_type = "t3.micro"


# ---------------------------------------------------------------------------------------------------
# env/prod.tfvars

environment = "prod"
aws_region = "ap-south-1"
ami_id = "ami-01a00762f46d584a1"
instance_type = "t3.micro"


# terraform init 
# u want to run that env 
# terraform aply -var-file="env/dev.tfvars"

# terraform apply -var-file="env/stage.tfvars"

# terraform apply -var-file="env/prod.tfvars"