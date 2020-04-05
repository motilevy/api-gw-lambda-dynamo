resource "aws_dynamodb_table" "music" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "artist"
  range_key      = "song"

  attribute {
    name = "artist"
    type = "S"
  }

  attribute {
    name = "song"
    type = "S"
  }

  tags = {
    Name = var.name
  }
  provisioner "local-exec" {
    command = "python ${path.module}/load_music.py ${var.name}"
  }
}

output "arn" {
  value = aws_dynamodb_table.music.arn
}
output "name" {
  value = aws_dynamodb_table.music.id
}
