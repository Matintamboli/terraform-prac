# transforms and filter


provider "aws"{
    region = "ap-south-1"
}

variable "names" {
  default = ["Alice", "Bob", "Charlie"]
}

output "uppercase_names" {
  value = [for name in var.names : upper(name)]
}

output "filtered_names" {
  value = [for name in var.names : name if length(name) > 3]
}