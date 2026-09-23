# u neeed to write a script like apache.sh 
# u need to save ur key also 
# give permission to key to read only i.e 400
# nano apache2.sh 
# nano matin
# chmod 400 matin

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_ec2"{
    ami = "ami-01a00762f46d584a1"
    instance_type = "t3.micro"
    key_name = "matin"

    provisioner "local-exec"{
        command = "touch abc.txt"
    }

    provisioner "file"{
        source = "apache2.sh"
        destination = "/home/ubuntu/apache2.sh"
    }
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("matin")
        host = self.public_ip
    }

    provisioner "remote-exec"{
        inline = [
            "bash /home/ubuntu/apache2.sh",
            "touch remote.txt"
        ]
    }
    tags = {
        Name = "MyFirstEC2"
    }

}