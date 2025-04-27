
# OUTPUTS for when use count
# output "ec2_public_ip" {
#   value = aws_instance.my_instance[*].public_ip
# }

# output "ec2_private_ip" {
#   value = aws_instance.my_instance[*].private_ip
# }

# output "ec2_public_dns" {
#   value = aws_instance.my_instance[*].public_dns
# }



#OUTPUTS for when use for_each
output "ec2_public_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.public_ip
  ]
}

output "ec2_private_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.private_ip
  ]
}

output "ec2_public_dns" {
  value = [
    for instance in aws_instance.my_instance : instance.public_dns
  ]
}