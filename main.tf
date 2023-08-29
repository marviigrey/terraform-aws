/*
In this playground we  first created a vpc and a subnet
we then attched an internet gateway to the vpc.
we created route tables to direct traffic
*/
resource "aws_vpc" "my_new_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "dev"
  }
}
resource "aws_subnet" "my_Subnet_vpc1" {
  cidr_block        = "10.123.1.0/24"
  vpc_id            = aws_vpc.my_new_vpc.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true


  tags = {
    Name = "dev-public"
  }
}
resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.my_new_vpc.id

  tags = {
    Name = "new-igw"
  }
}

resource "aws_route_table" "my-pub_rt" {
  vpc_id = aws_vpc.my_new_vpc.id
  tags = {
    Name = "dev_public_rt"
  }
  }
  resource "aws_route" "default_route" {
    route_table_id = aws_route_table.my-pub_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
}
  resource "aws_route_table_association" "my_rt_assoc" {
  subnet_id      = aws_subnet.my_Subnet_vpc1.id
  route_table_id = aws_route_table.my-pub_rt.id
}
resource "aws_security_group" "my_sg" {
  name        = "dev_sg"
  description = "sg for inbound traffic"
  vpc_id      = aws_vpc.my_new_vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "my_auth" {
  key_name = "tfkey"
  public_key = file("~/.ssh/tfkey.pub")
}
resource "aws_instance" "devnode" {
  ami           = data.aws_ami.server_ami.id
  instance_type = "t2.micro"
  tags = {
    Name = "dev-node"
  }
  key_name = aws_key_pair.my_auth.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id = aws_subnet.my_Subnet_vpc1.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }
}
