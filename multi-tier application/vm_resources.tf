resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "xxxxxxx"
}


resource "aws_instance" "vmmain" {
  count         = 2
  ami           = "ami-07c88ef0bf7488110"
  instance_type = var.size

  root_block_device {
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }

  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = false
  subnet_id                   = element([aws_subnet.subnet1.id, aws_subnet.subnet2.id], count.index)
  vpc_security_group_ids      = [aws_security_group.sgmain.id]


  tags = {
    Name = "Webserver-${count.index}"
  }
}






