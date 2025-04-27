# key pair login

resource aws_key_pair my_key {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & Security Group for EC2 (VPC = Virtual Private Cloud)

resource aws_default_vpc default {

}

resource aws_security_group my_security_group {
    name = "automate-sg"
    description = "this will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id # VPC ID

    # inbound rules (InBound means I want to allow traffic from the internet to my EC2 instance)
     ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow SSH from anywhere
        description = "SSH access from anywhere"
     } 
     ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow HTTP from anywhere
        description = "HTTP access from anywhere"
     }
     ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # allow HTTP from anywhere
        description = "NodePort access from anywhere"
     }


    # outbound rules (OutBound means I want to allow traffic from my EC2 instance to the internet)
     egress {
        from_port = 0
        to_port = 0
        protocol = "-1" # all protocols means "TCP, UDP, ICMP, etc"
        cidr_blocks = ["0.0.0.0/0"] # allow all traffic to anywhere (I can serve anything from my EC2 instance)
        description = "Allow all outbound traffic"
     }
}

# EC2 Instance

resource aws_instance my_instance {
    key_name = aws_key_pair.my_key.key_name # key pair name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = var.ec2_instance_type # free tier eligible instance type
    ami = var.ec2_ami_id #ubuntu
    user_data = file("install_nginx.sh") # install nginx on EC2 instance

    root_block_device {
        volume_size = var.ec2_root_storage_size # 15 GB root volume size
        volume_type = "gp3" # General Purpose SSD
    }
    tags = {
        Name = "Nicks-EC2-Automate"
    }
}
 