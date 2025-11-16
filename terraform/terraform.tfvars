aws_region          = "ap-south-1"
project_name        = "zomato"
project_environment = "production"
ami_id              = "ami-0f9708d1cd2cfee41"
instance_type       = "t2.micro"
webserver_ports     = ["80", "443", "22"]
domain_name         = "solonest.shop"
webserver_hostname  = "terraform"
enable_public_ip    = true

# ✅ Added subnet info
subnet_id   = "subnet-0405019b56d3a7518"
subnet_name = "my-subnet"
