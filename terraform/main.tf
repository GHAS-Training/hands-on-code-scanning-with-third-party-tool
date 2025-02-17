provider "aws" {
  region = "us-east-1"
}

# **Vulnerability: Hardcoded AWS Access Key & Secret Key** (Checkov: CKV_AWS_41)
provider "aws" {
  access_key = "AKIAFAKEACCESSKEY"
  secret_key = "fakeSecretKey123"
  region     = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket"
  acl    = "public-read" # **Vulnerability: Public S3 Bucket** (Checkov: CKV_AWS_18)

  tags = {
    Name        = "Insecure S3 Bucket"
    Environment = "Dev"
  }
}

resource "aws_security_group" "open_sg" {
  name        = "open-security-group"
  description = "Allow all inbound traffic"
  vpc_id      = "vpc-123456"

  # **Vulnerability: Open SSH Access to the World** (Checkov: CKV_AWS_24)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # **Vulnerability: Open RDP Access to the World** (Checkov: CKV_AWS_21)
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "insecure_instance" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  # **Vulnerability: Hardcoded User Data with Sensitive Information** (Checkov: CKV_AWS_8)
  user_data = <<-EOF
              #!/bin/bash
              echo "root:insecurepassword" | chpasswd
              EOF

  tags = {
    Name = "Insecure EC2 Instance"
  }
}