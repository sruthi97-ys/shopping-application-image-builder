# Key Pair
resource "aws_key_pair" "authentication_key" {
  key_name   = "${var.project_name}-${var.project_environment}"
  public_key = file("mykey.pub")

  tags = {
    Name = "${var.project_name}-${var.project_environment}"
  }
}

# Security Group
resource "aws_security_group" "webserver" {
  name        = "${var.project_name}-${var.project_environment}-webserver"
  description = "${var.project_name}-${var.project_environment}-webserver"

  tags = {
    Name = "${var.project_name}-${var.project_environment}-webserver"
  }
}

# Egress Rule
resource "aws_security_group_rule" "webserver_egress" {
  type              = "egress"
  security_group_id = aws_security_group.webserver.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# Ingress Rules
resource "aws_security_group_rule" "webserver_ingress" {
  for_each          = toset(var.webserver_ports)
  type              = "ingress"
  security_group_id = aws_security_group.webserver.id
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

# EC2 Instance
resource "aws_instance" "webserver" {

  ami                    = data.aws_ami.application_image.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.authentication_key.key_name
  vpc_security_group_ids = [aws_security_group.webserver.id]

  # Added Subnet ID
  subnet_id = var.subnet_id

  # Public IP
  associate_public_ip_address = var.enable_public_ip

  tags = {
    Name = "webserver-${var.project_name}-${var.project_environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
