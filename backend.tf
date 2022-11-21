terraform {
  backend "s3" {
    bucket = "terra-javaapp-state1"
    key    = "terra/backend"
    region = "us-east-1"
  }
}