provider "aws" {
    region = var.region
}

terraform { 
    backend "s3"{}
}

### VPC
resource "aws_vpc" "production-vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true

    tags = {
        Name = "Production-vpc"
    }
}

### Public Subnet
resource "aws_subnet" "public-subnet-1" {
    cidr_block        = var.public-subnet-1-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}a"

    tags = {
        Name = "Public-subnet-1"
    }
}

resource "aws_subnet" "public-subnet-2" {
    cidr_block        = var.public-subnet-2-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}b"

    tags = {
        Name= "Public-subnet-2"
    }
}

resource "aws_subnet" "public-subnet-3" {
    cidr_block        = var.public-subnet-3-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}c"

    tags = {
        Name= "Public-subnet-3"
    }
}

### Private Subnet
resource "aws_subnet" "private-subnet-1" {
    cidr_block        = var.private-subnet-1-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}a"

    tags = {
        Name= "Private-subnet-1"
    }
}

resource "aws_subnet" "private-subnet-2" {
    cidr_block        = var.private-subnet-2-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}b"

    tags = {
        Name= "Private-subnet-2"
    }
}

resource "aws_subnet" "private-subnet-3" {
    cidr_block        = var.private-subnet-3-cidr
    vpc_id            = aws_vpc.production-vpc.id
    availability_zone = "${var.region}c"

    tags = {
        Name= "Private-subnet-3"
    }
}

### Public Route Table
resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.production-vpc.id

    tags = {
        Name = "Public-route-table"
    }
}

### Private Route Table
resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.production-vpc.id

    tags = {
        Name = "Private-route-table"
    }
}

### Public Route Table Association
resource "aws_route_table_association" "public-subnet-1-route-table" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-1.id
}

resource "aws_route_table_association" "public-subnet-2-route-table" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-2.id
}

resource "aws_route_table_association" "public-subnet-3-route-table" {
    route_table_id = aws_route_table.public-route-table.id
    subnet_id      = aws_subnet.public-subnet-3.id
}

### Private Route Table Association
resource "aws_route_table_association" "private-subnet-1-route-table" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id      = aws_subnet.private-subnet-1.id
}

resource "aws_route_table_association" "private-subnet-2-route-table" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id      = aws_subnet.private-subnet-2.id
}

resource "aws_route_table_association" "private-subnet-3-route-table" {
    route_table_id = aws_route_table.private-route-table.id
    subnet_id      = aws_subnet.private-subnet-3.id
}

### Elastic IP
resource "aws_eip" "elastic-ip-for-nat-gw" {
    vpc                       = true
    associate_with_private_ip = "10.0.0.5"

    tags = {
        Name = "Production-EIP"
    }
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = aws_eip.elastic-ip-for-nat-gw.id
    subnet_id     = aws_subnet.public-subnet-1.id

    depends_on    = [aws_eip.elastic-ip-for-nat-gw]

    tags = {
        Name = "Production-NAT-GW"
    }
}

resource "aws_route" "nat-gw-route" {
    route_table_id         = aws_route_table.private-route-table.id
    nat_gateway_id         = aws_nat_gateway.nat-gw.id
    destination_cidr_block = "0.0.0.0/0"
}

### Public Gateway
resource "aws_internet_gateway" "production-igw" {
    vpc_id = aws_vpc.production-vpc.id

    tags = {
        Name = "Production-IGW"
    }
}

resource "aws_route" "public-internet-gw-route" {
    route_table_id         = aws_route_table.public-route-table.id
    gateway_id             = aws_internet_gateway.production-igw.id
    destination_cidr_block = "0.0.0.0/0"
}