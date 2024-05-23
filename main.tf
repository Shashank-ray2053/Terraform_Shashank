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
  

 









