variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0149b2da6ceec4bb0"
    us-east-2 = "ami-0149b2da6ceec4234"
  }
}

variable "private_key" {
  default = "appkey"
}

variable "public_key" {
  default = "appkey.pub"
}
variable "USERNAME" {
  default = "ubuntu"
}

variable "myip" {
  default = "109.249.181.13"
}

variable "rmquser" {
  default = "rabbit"
}

variable "rmqpass" {
  default = "1234@1234"
}

variable "dbname" {
  default = "admin"
}

variable "dbpass" {
  default = "admin"
}

variable "instance_count" {
  default = "1"
}

variable "VPC_name" {
  default = "javaapp-VPC"
}

variable "Zone1" {
  default = "us-east-1a"
}

variable "Zone2" {
  default = "us-east-1b"
}

variable "Zone3" {
  default = "us-east-1c"
}

variable "vpcCIDR" {
  default = "172.21.0.0/16"
}

variable "PubSub1CIDR" {
  default = "172.21.2.0/24"
}

variable "PubSub2CIDR" {
  default = "172.21.3.0/24"
}

variable "PubSub3CIDR" {
  default = "172.21.4.0/24"
}

variable "PriSub1CIDR" {
  default = "172.21.5.0/24"
}

variable "PriSub2CIDR" {
  default = "172.21.6.0/24"
}

variable "PriSub3CIDR" {
  default = "172.21.7.0/24"
}
