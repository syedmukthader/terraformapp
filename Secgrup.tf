resource "aws_security_group" "javaapp-bean-elb-sg" {

  name        = "javaapp-bean-elb-sg"
  description = "Security group for beanstalk-elb "
  vpc_id      = "module.vpc.vpc_id"
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "javaapp-bastion-sg" {

  name        = "javaapp-bastion-sg"
  description = "Sec grup for bastionhost EC2 instance"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.myip]
  }
}

resource "aws_security_group" "javaapp-ec2prodbs-sg" {
  name        = "javaapp-ec2prodbs-sg"
  description = "Security group for beanstalk instances"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.javaapp-bastion-sg.id]
  }

}

resource "aws_security_group" "javaapp-backend-sg" {
  name        = "javaapp-backend-sg"
  description = "SG for RDS , active mq, elastic cache"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.javaapp-ec2prodbs-sg.id]
  }
}

resource "aws_security_group_rule" "sec_group_allow_itself" {
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.javaapp-backend-sg.id
  source_security_group_id = aws_security_group.javaapp-backend-sg.id
  to_port                  = 65535
  type                     = "ingress"
}