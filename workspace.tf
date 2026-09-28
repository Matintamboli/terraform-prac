# mkdir terraform-workspace-demo
# cd terraform-workspace-demo


provider "aws"{
    region = "ap-south-1"
}

resource "aws_s3_bucket" "exmaple"{
    bucket = "example-bucket-${terraform.workspace}"
    acl = "private"

    tags = {
        Name = "workspace-demo"
        
    }
}


# terraform init

# terraform workspace list

# terraform workspace new dev
# terraform workspace new stage
# terraform workspace new prod


# terraform workspace select <workspace_name>
# terraform workspace select dev
# terraform apply