resource "aws_vpc" "wcs-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc-name
  }
}

resource "aws_subnet" "wcs-public-subnet" {
  vpc_id     = aws_vpc.wcs-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = var.subnet-name
  }
}

resource "aws_internet_gateway" "wcs-igw" {
  vpc_id = aws_vpc.wcs-vpc.id
  tags = {
    Name = var.igw-name
  }
}

resource "aws_route_table" "wcs-rt" {
  vpc_id = aws_vpc.wcs-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wcs-igw.id
  }
  tags = {
    Name = var.rt-name
  }
}

resource "aws_route_table_association" "wcs-public-rt-a" {
  subnet_id      = aws_subnet.wcs-public-subnet.id
  route_table_id = aws_route_table.wcs-rt.id
}

resource "aws_security_group" "wcs-sg" {
  name        = var.sg-name
  description = "allow inbound traffic on specific ports and all outbound traffic"
  vpc_id      = aws_vpc.wcs-vpc.id
  ingress = [
    for port in [22, 80] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.sg-name
  }
}