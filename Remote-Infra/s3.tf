resource "aws_s3_bucket" "my_state_bucket" {
  bucket = "nicks-state-bucket"

  tags = {
    Name        = "nicks-state-bucket"
  }
}