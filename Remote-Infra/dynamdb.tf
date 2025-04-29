resource "aws_dynamodb_table" "my_state_table" {
  name           = "nicks-state-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "nicks-state-table"
  }
}