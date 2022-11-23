resource "aws_elastic_beanstalk_environment" "javaapp-bean-prod" {
  application         = aws_elastic_beanstalk_application.javaapp-prod.name
  name                = "javaapp-bean-prod"
  solution_stack_name = "64bit Amazon Linux 2 v4.1.1 running Tomcat 8.5 Corretto 11"
  cname_prefix        = "javaapp-bean-prod-domain"
  setting {
    name      = "VPCid"
    namespace = "aws:ec2:vpc"
    value     = module.vpc.vpc_id
  }
  setting {
    name      = "IamInstanceProfile"
    namespace = "aws:autoscaling:launcherconfiguration"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    name      = "AssociatePublicIpAddress"
    namespace = "aws:ec2:vpc"
    value     = "false"
  }
  setting {
    name      = "Subnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
  }
  setting {
    name      = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }
  setting {
    name      = "InstanceType"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = "t2.micro"
  }
  setting {
    name      = "EC2keyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_key_pair.javaappkey.key_name
  }
  setting {
    name      = "Availability Zones"
    namespace = "aws:autoscaling:asg"
    value     = "Any 2"
  }
  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    value     = "1"
  }
  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value     = "4"
  }
  setting {
    name      = "environment"
    namespace = "aws:elasticbeanstalk:application:environment"
    value     = "prod"
  }
  setting {
    name      = "Logs "
    namespace = "aws:elasticbeanstalk:application:environment"
    value     = "GRAYLOG"
  }
  setting {
    name      = "Systemtype" #for Health monitoring
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "enhanced"
  }

  setting {
    name      = "RollingupdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "true"
  }
  setting {
    name      = "RollingupdateType"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "Health"
  }
  setting {
    name      = "Maxbatchsize"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "1"
  }
  setting {
    name      = "crosszone"
    namespace = "aws:elb:loadbalancer"
    value     = "true"
  }
  setting {
    name      = "StickinessEnable"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "true"
  }
  setting {
    name      = "BatchsizeType"
    namespace = "aws:elasticbeanstalk:command"
    value     = "fixed"
  }
  setting {
    name      = "Batchsize"
    namespace = "aws:elasticbeanstalk:command"
    value     = "1"
  }
  setting {
    name      = "DeploymentPolicy"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Rolling"
  }
  setting {
    name      = "SecurityGrup"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_security_group.javaapp-ec2prodbs-sg.id
  }

  setting {
    name      = "SecurityGrupElb"
    namespace = "aws:elbv2:loadbalancer"
    value     = aws_security_group.javaapp-bean-elb-sg.id
  }
  depends_on = [aws_security_group.javaapp-bean-elb-sg, aws_security_group.javaapp-ec2prodbs-sg]
}