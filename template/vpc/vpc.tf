variable "environment" {
  description = "The environment to deploy (dev, test, prod, stagging)"
  type        = string
}

# 1. Create VPC
resource "aws_vpc" "vpc_root" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-VPCRoot"
  }
}

# 2. Create Public Subnet (Production UI Server)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_root.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-PublicSubnet"
  }
}

# 3. Create Private Subnet (Database Server)
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_root.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "${var.environment}-PrivateSubnet"
  }
}

# 4. Create Dummy Subnet (Placeholder)
resource "aws_subnet" "dummy_subnet" {
  vpc_id            = aws_vpc.vpc_root.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-2c"

  tags = {
    Name = "${var.environment}-DummySubnet"
  }
}


# 5. Create Internet Gateway
resource "aws_internet_gateway" "igw_public" {
  vpc_id = aws_vpc.vpc_root.id

  tags = {
    Name = "${var.environment}-IGW-Public"
  }
}

# 6. Create Route Table for Public Subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_root.id

  tags = {
    Name = "${var.environment}-PublicRouteTable"
  }
}


# 7. Add Route to Internet Gateway in Public Route Table
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_public.id
}


# 8. Associate Public Subnets to Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "dummy_subnet_assoc" {
  subnet_id      = aws_subnet.dummy_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# 9. Create Route Table for Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_root.id

  tags = {
    Name = "${var.environment}-PrivateRouteTable"
  }
}

# 10. Associate Private Subnet to Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}


# 11. Create Security Groups
## Public Security Group (For Internet-Facing Web Server)
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.vpc_root.id
  name   = "${var.environment}-PublicSG"
  description = "Security Group for Internet facing web server"

  # Inbound Rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP from Load Balancer"
    security_groups = [aws_security_group.loadbalancer_sg.id]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow HTTPS from Load Balancer"
    security_groups = [aws_security_group.loadbalancer_sg.id]
  }

  # Custom TCP Ports (11000-11050, 10070, 1433)
  dynamic "ingress" {
    for_each = [11000, 11005, 11010, 11015, 11020, 11025, 11030, 11035, 11040, 11045, 11050, 10070, 1433]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      description = "Custom TCP Rule"
      self = true
    }
  }

  # Outbound Rules (Allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-PublicSG"
  }
}


## Private Security Group (For Database Server)
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.vpc_root.id
  name   = "${var.environment}-PrivateSG"
  description = "Security Group for private resources such as database server"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    description = "Allow MSSQL from Public SG"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-PrivateSG"
  }
}

## Load Balancer Security Group
resource "aws_security_group" "loadbalancer_sg" {
  vpc_id = aws_vpc.vpc_root.id
  name   = "${var.environment}-LoadBalancer"
  description = "Security Group for Load Balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow HTTP from all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow HTTPS from all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-LoadBalancerSG"
  }
}

//End of Prod VPC Section