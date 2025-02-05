


#NacL

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpcmain.id

  egress {
    rule_no    = 100
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"

  }
}


# Create VPC
resource "aws_vpc" "vpcmain" {
  cidr_block = var.VPC_CIDR
  tags = {
    Name = "main-vpc"
  }
}



# Create Subnet
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB1_CIDR
  availability_zone = var.zone1

  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB2_CIDR
  availability_zone = var.zone2

  tags = {
    Name = "subnet-2"
  }
}

# Attach Internet Gateway
resource "aws_internet_gateway" "gwmain" {
  vpc_id = aws_vpc.vpcmain.id

  tags = {
    Name = "main-igw"
  }
}



resource "aws_subnet" "subnet3" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB3_CIDR
  availability_zone = var.zone1

  tags = {
    Name = "subnet-3"
  }
}


resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB4_CIDR
  availability_zone = var.zone2

  tags = {
    Name = "subnet-4"
  }
}


resource "aws_subnet" "subnet5" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB5_CIDR
  availability_zone = var.zone1

  tags = {
    Name = "subnet-5"
  }
}

resource "aws_subnet" "subnet6" {
  vpc_id            = aws_vpc.vpcmain.id
  cidr_block        = var.SUB6_CIDR
  availability_zone = var.zone2


  tags = {
    Name = "subnet-6"
  }
}


resource "aws_eip" "nat_eip" {
  associate_with_private_ip = true
}

# Create the NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id
  tags = {
    Name = "nat-gateway"
  }
}




# Create Route Tables
resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.vpcmain.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwmain.id
  }


  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table" "route2" {
  vpc_id = aws_vpc.vpcmain.id
  tags = {
    Name = "redis-route-table"
  }
}

resource "aws_route_table" "route3" {
  vpc_id = aws_vpc.vpcmain.id
  tags = {
    Name = "mysql-route-table"
  }
}




# Associate Route Table with Subnet
resource "aws_route_table_association" "asomain" {
  for_each       = { subnet1 = aws_subnet.subnet1.id, subnet2 = aws_subnet.subnet2.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.route1.id
}


resource "aws_route_table_association" "asomainredis" {
  for_each       = { subnet3 = aws_subnet.subnet3.id, subnet4 = aws_subnet.subnet4.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.route2.id
}

resource "aws_route_table_association" "asomainmysql" {
  for_each       = { subnet5 = aws_subnet.subnet5.id, subnet6 = aws_subnet.subnet6.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.route3.id
}



# Security group
resource "aws_security_group" "sgmain" {
  vpc_id = aws_vpc.vpcmain.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "cluster99-sg-redis"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.vpcmain.id

  ingress {
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "cluster99-sg"
  description = "Security group for Redis cluster"
  vpc_id      = aws_vpc.vpcmain.id

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }
}