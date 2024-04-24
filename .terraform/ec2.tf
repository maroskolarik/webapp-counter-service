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

  provisioner "file" {
    source      = "./conf/wcs-server-dc.yml"
    destination = "/home/ubuntu/server-dc.yml"
  }

  provisioner "file" {
    source      = "./conf/prometheus.yml"
    destination = "/home/ubuntu/prometheus.yml"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}