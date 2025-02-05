resource "aws_db_subnet_group" "mysql_db_subnet_group" {
  name       = "mysql-db-subnet-group"
  subnet_ids = [aws_subnet.subnet5.id, aws_subnet.subnet6.id]
  tags = {
    Name = "mysql-db-subnet-group"
  }


}



resource "aws_db_instance" "mysql_primary" {
  identifier              = "mysql-primary"
  engine                  = "mysql"
  engine_version          = "8.0"
  multi_az                = true
  instance_class          = "db.t3.medium"
  allocated_storage       = "20"
  storage_type            = "gp2"
  backup_retention_period = 1

  username               = var.mysql_username
  password               = var.mysql_password
  db_name                = var.mysql_db_name
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql_db_subnet_group.name
}

resource "time_sleep" "wait_primary" {
  depends_on      = [aws_db_instance.mysql_primary]
  create_duration = "200s" # Wait 5 minutes for automated backups to kick in
}

resource "aws_db_instance" "mysql_replica" {
  depends_on             = [aws_db_instance.mysql_primary, time_sleep.wait_primary]
  identifier             = "mysql-replica"
  engine                 = aws_db_instance.mysql_primary.engine
  engine_version         = aws_db_instance.mysql_primary.engine_version
  instance_class         = "db.t3.medium"
  storage_type           = "gp2"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  replicate_source_db    = aws_db_instance.mysql_primary.arn
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.mysql_db_subnet_group.name
}