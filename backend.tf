resource "aws_db_subnet_group" "javaapp-rds-subgrp" {

  name       = "main"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "Subnet Grup for RDS"
  }
}

resource "aws_elasticache_subnet_group" "javaapp-ecache-subgrp" {
  name       = "javaapp-ecache-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "Subnet Grp for ECACHE"
  }
}

resource "aws_db_instance" "javaapp-rds" {
  allocated_storage      = 20
  instance_class         = "db.t2.micro"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.6"
  parameter_group_name   = "default.my.sql5.6"
  multi_az               = "false"
  publicly_accessible    = "false"
  skip_final_snapshot    = true # true if want to delete the snapshot / false for saving  snapshot
  db_subnet_group_name   = aws_db_subnet_group.javaapp-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.javaapp-backend-sg.id]
  db_name                = var.dbname
  username               = var.dbusername
  password               = var.dbpass
}

resource "aws_elasticache_cluster" "javaapp-cache" {
  cluster_id           = "javaapp-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  security_group_ids   = [aws_security_group.javaapp-backend-sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.javaapp-ecache-subgrp.name
}

resource "aws_mq_broker" "javaapp-rmq" {
  broker_name        = "javaapp-rmq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.javaapp-backend-sg.id]

  user {
    password = var.rmqpass #coming from variable file
    username = var.rmquser
  }
}