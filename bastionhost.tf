resource "aws_instance" "javaapp-bastion" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.javaappkey.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.javaapp-bastion-sg.id]

  tags = {
    Name    = "JavaApp-bastion"
    PROJECT = "JavaApp"
  }

  provisioner "file" {
    content     = templatefile("templates/db-deploy.tmpl", { rds-endpoint = aws_db_instance.javaapp-rds1.address, dbusername = var.dbusername, dbpass = var.dbpass })
    destination = "/tmp/javaapp-dbdeploy.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/javaapp-dbdeploy.sh",
      "sudo /tmp/javaapp-dbdeploy.sh"
    ]
  }
  connection {
    user        = var.USERNAME
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
  depends_on = [aws_db_instance.javaapp-rds1]
}