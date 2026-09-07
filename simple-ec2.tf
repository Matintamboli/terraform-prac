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
