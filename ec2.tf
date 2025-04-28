# key pair login

resource "aws_key_pair" "my_key" {
  key_name   = "${var.env}-terra-key-ec2" # Name of the key pair
  public_key = file("terra-key-ec2.pub")
  tags = {
    Name        = "${var.env}-terra-key-ec2" # Name of the key pair
    Environment = var.env # Environment (dev/prod)
  }
}

# VPC & Security Group for EC2 (VPC = Virtual Private Cloud)

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "${var.env}-automate-sg"
  description = "this will add a TF generated security group"
  vpc_id      = aws_default_vpc.default.id # VPC ID

  # inbound rules (InBound means I want to allow traffic from the internet to my EC2 instance)
  dynamic "ingress" {
    for_each = var.allow_ssh ? [1] : [] # if allow_ssh is true, create ingress rule for SSH
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # allow SSH from anywhere
      description = "SSH access from anywhere"
    }
  }
  dynamic "ingress" {
    for_each = var.allow_http ? [1] : [] # Only create HTTP rule if allow_http is true
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access from anywhere"
    }
  }
  dynamic "ingress" {
    for_each = var.allow_nodeport ? [1] : [] # Only create NodePort rule if allow_nodeport is true
    content {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "NodePort access from anywhere"
    }
  }

  # outbound rules (OutBound means I want to allow traffic from my EC2 instance to the internet)
  dynamic "egress" {
    for_each = var.outbound_traffic_allowed ? [1] : [] # Create egress if allowed
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # All protocols
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  }

  # tags for the security group
  tags = {
    Name        = "${var.env}-automate-sg" # Name of the security group
    Environment = var.env # Environment (dev/prod)
  }
}

# EC2 Instance
resource "aws_instance" "my_instance" {
  # count           = 2                        # create 2 EC2 instances
  for_each = tomap({
    Nicks-EC2-Automate-micro  = "t2.micro",
    Nicks-EC2-Automate-microo = "t2.micro",
  })                                             # create 2 EC2 instances with different names and same type # META ARGUMENTS
  key_name        = aws_key_pair.my_key.key_name # key pair name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id           #ubuntu
  user_data       = file("install_nginx.sh") # install nginx on EC2 instance

  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key] # wait for security group and key pair to be created before creating EC2 instance

  root_block_device {
    volume_size = var.env == "prod" ? var.ec2_root_storage_size : var.ec2_root_default_storage_size # 15 GB for dev and 10 GB for prod
    volume_type = "gp3"                                                                             # General Purpose SSD
  }
  tags = {
    Name = each.key # Name of the EC2 instance
    Environment = var.env # Environment (dev/prod)
  }
}
