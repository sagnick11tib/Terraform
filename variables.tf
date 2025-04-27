variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_root_storage_size" {
  default = 15
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-0e35ddab05955cf57" #ubuntu
  type    = string
}


# chmod 400 terra-key-ec2.pem
# ssh -i terra-key-ec2 ubuntu@ec2-3-109-206-131.ap-south-1.compute.amazonaws.com