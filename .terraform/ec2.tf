resource "aws_instance" "wcs-server" {
  ami                         = var.instance-ami
  instance_type               = var.instance-type
  key_name                    = var.key-name
  subnet_id                   = aws_subnet.wcs-public-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wcs-sg.id]
  user_data                   = file("./scripts/wcs-server-tools.sh")
  tags = {
    Name = "wcs-server"
  }
}

resource "aws_instance" "wcs-monitoring" {
  ami                         = var.instance-ami
  instance_type               = var.instance-type
  key_name                    = var.key-name
  subnet_id                   = aws_subnet.wcs-public-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.wcs-sg.id]
  user_data                   = file("./scripts/wcs-monitoring-tools.sh")
  tags = {
    Name = "wcs-monitoring"
  }
}