
provider "aws" {
  region = "ap-south-1"   
}


resource "aws_instance" "my_ec2" {
  for_each = toset(var.ami_ids)
  ami = each.value
  instance_type = "t3.micro"

#  count = 3
  tags = {
    Name = "MyFirstEC2"
  }
}

variable "ami_ids" {
    default = ["ami-01a00762f46d584a1", "ami-08188a5a4dfdbd573"]
    type = list(string)
}

output "public_ip" {
    value = { for instance in aws_instance.my_ec2: instance.id => instance.arn }
}

variable "names" {
  default = ["Alice", "Bob", "Charlie"]
}

output "uppercase_names" {
  value = [for name in var.names : upper(name)]
}