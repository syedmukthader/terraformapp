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
  storage_type           = "gp2"
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = var.dbusername
  password               = var.dbpass
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true # true if want to delete the snapshot / false for saving  snapshot
  multi_az               = "false"
  publicly_accessible    = "false"
  db_subnet_group_name   = aws_db_subnet_group.javaapp-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.javaapp-backend-sg.id]
}

resource "aws_elasticache_cluster" "javaapp-cache" {
  cluster_id           = "javaapp-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
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
  subnet_ids         = [module.vpc.public_subnets[0]]
  user {
    password = var.rmqpass #coming from variable file
    username = var.rmquser
  }
}