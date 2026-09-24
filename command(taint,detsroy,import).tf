# taint is outdate , use -replace 
# it will destroy and recreate that resource

# terraform apply -replace="aws_instance.my_ec2"



# import is for import existing resource that lies in aws  
# terraform import <resouce> <resource_id>

# like terraform import aws_instnace.my_instance i-xxxxx




# terraform destroy destroy's all resource 
# if we want to delete specific resource we use -target flag

# terraform destroy -target=aws_instance.my_ec2


provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "my-ec2"{
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"

    tags ={
        Name = "cmd-instance"
    }
}