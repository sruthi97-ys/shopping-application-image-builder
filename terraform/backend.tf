terraform {
  backend "s3" {
    bucket = "terraform-backend.solonest.shop"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

