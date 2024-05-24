terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version =  "~> 5.0"
    }
  }
  
}

#select the provider and region
provider "aws" {
    #region must be specified accourding to users choice
    region = "us-east-1"
  
}

#Define VPC

resource "aws_vpc" "shashank_vpc_adex" {
    cidr_block = "10.0.0.0/24"

    tags = {
      Name = "shashank_vpc_adex"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"

    }
  
}

# Define SUBNET (1 public, 2 private)

resource "aws_subnet" "skr_sbn_public"{
//availability_zone = "us-east-1a"
cidr_block = "10.0.0.0/26"
vpc_id = aws_vpc.shashank_vpc_adex.id

tags = {
    Name = "public_subnet"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
}

}
resource "aws_subnet" "skr_sbn_private1"{
//availability_zone = "us-east-1a"
cidr_block = "10.0.0.64/26"
vpc_id = aws_vpc.shashank_vpc_adex.id


tags = {
    Name = "private1_subnet"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
}

}
resource "aws_subnet" "skr_sbn_private2"{
//availability_zone = "us-east-1a"
cidr_block = "10.0.0.128/26"
vpc_id = aws_vpc.shashank_vpc_adex.id

tags = {
    Name = "private2_subnet"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
}

}
#INTERNET-GATEWAY

resource "aws_internet_gateway" "skr_gw" {
  vpc_id = aws_vpc.shashank_vpc_adex.id

  tags = {
    Name = "skr_gateway"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
}
  }
  
  #create NAT-gateway

  resource "aws_nat_gateway" "skr_nat_gateway" {
  //allocation_id = aws_eip.example.id
  connectivity_type = "private"
  subnet_id     = aws_subnet.skr_sbn_public.id

  tags = {
    Name = "skr_nat_gateway"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  #depends_on = [aws_internet_gateway.example]
}

#security group

resource "aws_security_group" "skr_seccurity_group" {
  vpc_id = aws_vpc.shashank_vpc_adex.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  tags = {
    Name = "SHASHANK_SSH"
      silo = "Intern2"
      owner = "shashank.ray"
      environment = "Dev"
      terraform = "true"
  }
}

#outputs

output "vpc_id" {
  value = aws_vpc.shashank_vpc_adex.id
}

output "public_subnet_id" {
  value = aws_subnet.skr_sbn_public.id
}

output "private_subnet1_id" {
  value = aws_subnet.skr_sbn_private1.id
}

output "private_subnet2_id" {
  value = aws_subnet.skr_sbn_private2.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.skr_gw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.skr_nat_gateway.id
}

#variables

variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  default     = "default"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/24"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  default     = "10.0.0.0/26"
}

variable "private_subnet1_cidr" {
  description = "The CIDR block for the first private subnet"
  default     = "10.0.0.64/26"
}

variable "private_subnet2_cidr" {
  description = "The CIDR block for the second private subnet"
  default     = "10.0.0.128/26"
}

variable "availability_zone" {
  description = "The availability zone for the subnets"
  default     = "us-east-1a"
}


#route-table

resource "aws_route_table" "skr_rt_public" {
  vpc_id = aws_vpc.shashank_vpc_adex.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.skr_gw.id
  }

  tags = {
    Name = "skr_public-route-table"
  }
}

resource "aws_route_table" "skr_rt_private" {
  vpc_id = aws_vpc.shashank_vpc_adex.id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.skr_nat_gateway.id
  }

  tags = {
    Name = "skr_private-route-table"
  }
}

resource "aws_route_table_association" "skr_public" {
  subnet_id      = aws_subnet.skr_sbn_public.id
  route_table_id = aws_route_table.skr_rt_public.id
}

resource "aws_route_table_association" "skr_private1" {
  subnet_id      = aws_subnet.skr_sbn_private1.id
  route_table_id = aws_route_table.skr_rt_private.id
}

resource "aws_route_table_association" "skr_private2" {
  subnet_id      = aws_subnet.skr_sbn_private2.id
  route_table_id = aws_route_table.skr_rt_private.id
}

 









