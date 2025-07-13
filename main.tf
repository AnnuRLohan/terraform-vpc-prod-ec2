provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}


resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  tags  = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id        = aws_vpc.main.id 
  tags = {
    Name    = "${var.project}-igw"
  }
}

resource "aws_eip" "nat" {
    tags = {
      Name = "${var.project}-eip"
    }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.project}-natgw"
  }
}

resource "aws_subnet" "public" {
  count         = 2
  vpc_id        = aws_vpc.main.id
  cidr_block    = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project}-public-${count.index +1}"
  }
}

resource "aws_subnet" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.project}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id    = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name  = "${var.project}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id    = aws_vpc.main.id
  route  {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id    = aws_nat_gateway.natgw.id
  }
  tags = {
    Name    = "${var.project}-private-rt"
  }
}

resource "aws_route_table_association" "public" {
    count     = 2
    subnet_id     = aws_subnet.public[count.index].id
    route_table_id  = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count   = 2
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
