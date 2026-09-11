# creating modules , root files , modules files

# 1st we have to create proj dir 
# create main, variable, output files in root
# in that modules folder , in module folder vpc, subnet, ec2 folder i.e root and child dir 
# in vpc, subnet, ec2 .... main, variable, output files

# mkdir terraform-project
# cd terraform-project

# mkdir -p modules/vpc modules/subnet modules/ec2

# touch main.tf variables.tf outputs.tf provider.tf 

# touch modules/vpc/{main.tf,variables.tf,outputs.tf} \
#       modules/subnet/{main.tf,variables.tf,outputs.tf} \
#       modules/ec2/{main.tf,variables.tf,outputs.tf}

# --------------------------------------------------------------------------------------------

# Root/variable.tf

variable "aws_region" {
    description = "AWS region"
    type =  string
    default = "ap-south-1"
}

variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    description = "CIDR block for Subnet"
    type = string
    default = "10.0.0.0/24"
}

variable "instance_type" {
    description = "Instance type of EC2"
    type = string
    default = "t3.micro"
}

# --------------------------------------------------------------------------------------

# root/provider.tf

provider "aws" {
    region = var.aws_region
}

# --------------------------------------------------------------------------------------

# root/main.tf

module "vpc" {
    source = "./modules.vpc"
    vpc_cidr = var.vpc_cidr
}

module "subnet" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    subnet_cidr = var.subnet_cidr
}

module "ec2" {
  source        = "./modules/ec2"
  subnet_id     = module.subnet.subnet_id
  instance_type = var.instance_type
}

# --------------------------------------------------------------------------------------

# root/outputs.tf

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "subnet_id" {
    value = module.vpc.subnet_id
}

output "instance_id" {
    value = module.vpc.instance_id
}

# --------------------------------------------------------------------------------------

# modules/vpc/variables.tf
 variable "vpc_cidr" {
    description = "VPC CIDR block"
    type = string
 }


# --------------------------------------------------------------------------------------

# modules/vpc/main.tf

resource "aws_vpc"  "this" {
    cidr_block = var.vpc_id

    tags = {
      Name = "MyVPC"
    }
}


# --------------------------------------------------------------------------------------

# modules/vpc/outputs.tf

output "vpc_id" {
    value = aws_vpc.this.id
}

# --------------------------------------------------------------------------------------

# modules/subnet/variables.tf

variable "vpc_id" {
  description = "VPC ID from VPC module"
  type = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type = string
}

# --------------------------------------------------------------------------------------

# modules/subnet/main.tf

resource "aws_subnet" "this" {
  vpc_id = var.vpc_cidr

  tags = {
    Name = "MySubnet"
  }
}

# --------------------------------------------------------------------------------------

# modules/subnet/output.tf

output "subnet_id" {
  value = aws_subnet.this.id
}

# --------------------------------------------------------------------------------------

# modules/ec2/variables.tf

variable "subnet_id" {
  description = "Subnet ID from subnet module"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
}

# --------------------------------------------------------------------------------------

# modules/ec2/main.tf

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource"aws_instance" "this" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id

  tags = {
    Name = "MyEC2"
  }
}

# --------------------------------------------------------------------------------------

# modules/ec2/outputs.tf

output "instance_id" {
  value = aws_instance.this
}