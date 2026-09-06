#####################################
# MIGRATED APPLICATION SERVER 1
#####################################

resource "aws_instance" "migration_server_1" {
  ami           = var.migration_ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [
    aws_security_group.migration_workload.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = false

  tags = {
    Name        = "migration-server-1"
    Environment = "production"
    Role        = "migrated-workload"
  }
}


#####################################
# MIGRATED APPLICATION SERVER 2
#####################################

resource "aws_instance" "migration_server_2" {
  ami           = var.migration_ami_id
  instance_type = var.instance_type

  subnet_id = aws_subnet.private.id

  vpc_security_group_ids = [
    aws_security_group.migration_workload.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = false

  tags = {
    Name        = "migration-server-2"
    Environment = "production"
    Role        = "migrated-workload"
  }
}


#####################################
# ALB TARGET - SERVER 1
#####################################

resource "aws_lb_target_group_attachment" "migration_server_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.migration_server_1.id
  port             = 80
}


#####################################
# ALB TARGET - SERVER 2
#####################################

resource "aws_lb_target_group_attachment" "migration_server_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.migration_server_2.id
  port             = 80
}