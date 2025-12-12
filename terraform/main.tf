/*# terraform/main.tf

provider "aws" {
  region = var.aws_region
}

# --- DATA SOURCES TO FIND NETWORKING INFO ---
# This block finds the default VPC for the specified region
data "aws_vpc" "default" {
  default = true
}

# This block finds the first available subnet in the default VPC's 'a' availability zone
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "${var.aws_region}a"
}

# --- RESOURCES TO CREATE ---

resource "aws_security_group" "nexus_sg" {
  name        = "nexus-sg-tf"
  description = "Allow SSH and Nexus traffic"
  vpc_id      = data.aws_vpc.default.id # Attach the SG to the default VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
    description = "Allow SSH from my IP"
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
    description = "Allow Nexus HTTP from my IP"
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
    description = "Allow Nexus HTTPS from my IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "nexus-sg-tf"
  }
}

resource "aws_instance" "nexus_server" {
  ami                    = "ami-068c0051b15cdb816" # Amazon Linux 2023 AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]
  subnet_id              = data.aws_subnet.default.id # <-- KEY CHANGE: Explicitly set the subnet
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e -x

              # Install Docker
              dnf update -y
              dnf install -y docker

              # Start and enable Docker
              systemctl start docker
              systemctl enable docker

              # Add ec2-user to docker group
              usermod -a -G docker ec2-user

              # Run the Nexus container with our fixes
              docker run -d -p 8081:8081 -p 8443:8443 -e INSTALL4J_ADD_VM_PARAMS="-Xms512m -Xmx1200m" -e HOME=/nexus-data --name nexus sonatype/nexus3
              EOF

  tags = {
    Name = "nexus-server-tf"
  }
}

# Generate the Ansible inventory file dynamically
resource "local_file" "ansible_inventory" {
content = <<-EOF
[nexus_server]
${aws_instance.nexus_server.public_ip}
EOF
filename = "${path.root}/../ansible/inventory.ini"
}*/


# new one

# Create a VPC to host our Nexus instance
resource "aws_vpc" "nexus_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "nexus-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "nexus_subnet" {
  vpc_id                  = aws_vpc.nexus_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "nexus-subnet"
  }
}

# Create an Internet Gateway to allow the instance to access the internet
resource "aws_internet_gateway" "nexus_igw" {
  vpc_id = aws_vpc.nexus_vpc.id
  tags = {
    Name = "nexus-igw"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "nexus_rt" {
  vpc_id = aws_vpc.nexus_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nexus_igw.id
  }
  tags = {
    Name = "nexus-rt"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "nexus_rta" {
  subnet_id      = aws_subnet.nexus_subnet.id
  route_table_id = aws_route_table.nexus_rt.id
}

# Create a security group to allow traffic to Nexus
resource "aws_security_group" "nexus_sg" {
  vpc_id = aws_vpc.nexus_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere. Restrict this in a real-world scenario.
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access to Nexus UI from anywhere.
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "nexus-sg"
  }
}

# Create the EC2 instance for Nexus
resource "aws_instance" "nexus" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.nexus_subnet.id
  vpc_security_group_ids = [aws_security_group.nexus_sg.id]

  # User data script to install Docker
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "nexus-server-v2"
  }
}