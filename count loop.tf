# count is used for define how many resources to create 
# creating identical resourses

provider "aws"{
    region = "ap-south-1"
}


resource "aws_instance" "ec2"{
    count = 3
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    key_name = "matin"

    tags ={
        Name = "instance_cnt"
    }
}