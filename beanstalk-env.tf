resource "aws_elastic_beanstalk_environment" "javaapp-bean-prod" {
  application = aws_elastic_beanstalk_application.javaapp-prod
  name        = "javaapp-bean-prod"


}