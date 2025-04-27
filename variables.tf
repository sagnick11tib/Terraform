variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_root_storage_size" {
  default = 15
  type    = number
}

variable "ec2_root_default_storage_size" {
  default = 10
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-0e35ddab05955cf57" #ubuntu
  type    = string
}

variable "env" {
  default = "prod"
  type    = string
}

variable "allow_ssh" {
  default = true
  type    = bool
}

variable "allow_http" {
  default = true
  type    = bool
}

variable "allow_nodeport" {
  default = false
  type    = bool
}

variable "outbound_traffic_allowed" {
  default = true
  type    = bool
}
