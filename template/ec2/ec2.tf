variable "vpc_id" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "public_sg_id" {}
variable "private_sg_id" {}
variable "db_ec2_instance_profile_name" {}
variable "ui_ami_id" {
  type = string
}
variable "db_ami_id" {
  type = string
}
variable "ui_key" {
  type = string
}
variable "db_key" {
  type = string
}

variable "environment" {
  type = string
}


##Uses an existing VPC, subnet, key pair, and security group.
##Attaches a 100GB gp2 EBS volume.
##Enables termination protection and stop protection.
##Associates an Elastic IP.
##Enables CloudWatch monitoring.
##Generates outputs for use with Route 53, Load Balancer, etc.

##1. Make sure to Add the new AWS Account Global ID to the AMI that we use in this script 
##if you are using for new AWS Account or cross AWS Account or cross AWS Account
##2. Make sure create two key pairs one for UI and one for Database and make sure the pem file is properly stored.
##3. apply all the key pairds and AMI to the ec2 script.


//Create new Production UI EC2 Instance

resource "aws_instance" "ui_instance" {
  ami                  = var.ui_ami_id # Replace with actual AMI ID
  instance_type        = "t2.large"
  key_name            = var.ui_key # Make sure the Key Name is created in Env_UI_Key 
  vpc_security_group_ids = [var.public_sg_id] # Use module reference
  subnet_id           = var.public_subnet_id # Use module reference
  disable_api_termination = true # Enable termination protection
  ebs_optimized       = true
  monitoring          = true # Enable CloudWatch detailed monitoring


  root_block_device {
    volume_size           = 100
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-UI-Instance"
    Environment = "Production"
  }
}

resource "aws_eip" "ui_instance_eip" {
  domain   = "vpc"
  instance = aws_instance.ui_instance.id
}


//Create new Production Database EC2 Instance
resource "aws_instance" "db_instance" {
  ami                  = var.db_ami_id # Replace with actual AMI ID
  instance_type        = "t2.large"
  key_name            = var.db_key # Make sure the Key Name is created in Env_DB_Key
  vpc_security_group_ids = [var.private_sg_id] # Use module reference
  subnet_id           = var.private_subnet_id # Use module reference
  disable_api_termination = true # Enable termination protection
  ebs_optimized       = true
  monitoring          = true # Enable CloudWatch detailed monitoring
  iam_instance_profile = var.db_ec2_instance_profile_name
  
  root_block_device {
    volume_size           = 300
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-DB-Instance"
    Environment = "Production"
  }
}

resource "aws_ebs_volume" "db_volume" {
  availability_zone = aws_instance.db_instance.availability_zone
  size             = 300
  type             = "gp2"
  encrypted        = false
  tags = {
    Name = "${var.environment}-DB_Volume"
  }
}

resource "aws_volume_attachment" "db_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.db_volume.id
  instance_id = aws_instance.db_instance.id
}

resource "aws_eip" "db_instance_eip" {
  domain   = "vpc"
  instance = aws_instance.db_instance.id
}




