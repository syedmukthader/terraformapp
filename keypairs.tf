resource "aws_key_pair" "javaappkey" {
  key_name   = "javaappkey"
  public_key = file(var.public_key)
}
