# it will create 2 buckets 


provider "aws"{
    region = "ap-south-1"
}

resource "aws_s3_bucket" "example" {
  for_each = {
    dev  = "mt-dev-buck-3421"
    prod = "mt-prod-buck-1234"
  }

  bucket = each.value
}