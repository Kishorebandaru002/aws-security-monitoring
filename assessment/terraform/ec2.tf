#IAM Role and Instance Profile

#A role (for EC2 to assume)
#Attached the SSM policy
#Created an instance profile (to apply that role to the EC2 instance)

resource "aws_iam_role" "ssm_role" {
  name = "${var.project}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.project}-ssm-profile"
  role = aws_iam_role.ssm_role.name
}



#Security Group for EC2
#Since this EC2 instance is in a private subnet, we:
#WeDon’t expose any inbound ports to the internet
#Only allow traffic from within the VPC


resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-ec2-sg"
  description = "Security group for EC2 running Wazuh"
  vpc_id      = aws_vpc.main.id

#There is no SSH port (22)?
#Because we're using SSM Session Manager, which is more secure and doesn’t require SSH keys.


  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]  # Allow internal traffic only
    description      = "Allow internal HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.project}-ec2-sg"
  }
}


#We need an Ubuntu AMI that works in us-east-1 using ami-0fc5d935ebf8bc3bc

resource "aws_instance" "wazuh" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t3.xlarge"
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "${var.project}-wazuh-ec2"
  }
}






