resource "aws_key_pair" "appkey" {
  key_name = "appkey"
  public_key = file(var.public_key)
}
