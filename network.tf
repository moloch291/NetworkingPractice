######################################################################################
  # Internet gateway:
######################################################################################

# Internet gateway:
resource "aws_internet_gateway" "igw" {
    depends_on = [
        aws_vpc.main,
        aws_subnet.public_subnet_1,
        aws_subnet.public_subnet_2,
        aws_subnet.private_subnet_1,
        aws_subnet.private_subnet_2,
    ]

    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "igw"
    }
}

# Route table to public subnet:
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = "${aws_vpc.main.id}"

  depends_on = [
      aws_vpc.main,
      aws_internet_gateway.igw
  ]

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}

# Route table association
resource "aws_route_table_association" "rt_igw_association" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.public_subnet_1,
    aws_route_table.public_subnet_rt
  ]

  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

######################################################################################
  # NAT gateway:
######################################################################################

# NAT Elastic IP:
resource "aws_eip" "nat_gateway_eip" {
  depends_on = [
    aws_route_table_association.rt_igw_association
  ]
  vpc = true
}

# NAT gateway:
resource "aws_nat_gateway" "NATgw" {
  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat_gateway_eip
  ]

  allocation_id = aws_eip.nat_gateway_eip
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NATgw"
  }
}

# NAT gateway route table:
resource "aws_route_table" "NATgw_rt" {
  depends_on = [
    aws_nat_gateway.NATgw
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }
}

# Creating an Route Table Association of the NAT Gateway route 
# table with the Private Subnet!
resource "aws_route_table_association" "Nat-Gateway-RT-Association" {
  depends_on = [
    aws_route_table.NATgw_rt
  ]

  subnet_id      = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
  route_table_id = aws_route_table.NAT-Gateway-RT.id
}