#  AWS Security Monitoring Infrastructure

This project sets up a secure security monitoring stack in AWS using **Terraform**, **Docker Compose**, and **Wazuh** — as part of a cloud security engineer challenge.

---

## Components

-  AWS VPC with public & private subnets
-  NAT Gateway for private outbound internet access
-  EC2 instance in private subnet (for Wazuh)
-  IAM Role with SSM access (no SSH required)
-  Docker & Docker Compose installation script
-  Wazuh deployed via Docker Compose

---

##  Setup Instructions

###  Prerequisites

- AWS CLI installed & configured: `aws configure`
- Terraform installed: `terraform -v`
- Git installed: `git --version`

---

#1.Clone the Repository

                                                 -git clone https://github.com/Kishorebandaru002/aws-security-monitoring.git

#2. Configure AWS CLI
#3. Initialize and Deploy Terraform Infrastructure
                                                  -VPC with public/private subnets
                                                  -Internet Gateway + NAT Gateway
                                                  -Route tables
                                                  -Security group
                                                  -IAM role with SSM access
                                                  -EC2 instance (Ubuntu) in a private subnet






##  Access Information(System Manager)

 Since the EC2 instance is deployed in a private subnet, SSH is disabled.
 Instead, I use AWS Systems Manager Session Manager to securely access the instance
 Steps:
      -Open the AWS Console
      -Navigate to Systems Manager → Session Manager
      -Select your EC2 instance and click "Start Session"
      -You will get a secure shell terminal inside the instance
      (No need for SSH keys or exposed ports)

   
  Wazuh Deployment using Docker Compose
  After accessing the instance via SSM, deploy Wazuh by running the provided setup script
                                       EC2 Instance (SSM Session):

                                     cd /home/ubuntu
                                     nano setup.sh   # Paste the setup.sh contents from scripts directory
                                     chmod +x setup.sh
                                     sudo bash setup.sh



##  Basic Testing Steps

1. Verify Docker Containers - (docker ps)
2. Verify Wazuh UI is running (from within EC2) - (curl http://localhost:5601



Notes:
Ports like 5601, 1514, 1515 are exposed internally, not publicly.
All resources are tagged and scoped to the awssecurity.
The stack is deployed in a single-node mode suitable for demonstration.


##  Security Best Practices Used in this Project

     - Used IAM role for EC2 (No hardcoded keys or access credentials in Terraform or on the instance)
     - Network Security (EC2 instance runs in a private subnet with no public IP.)
     - SSM for access instead of SSH (No need to open port 22 or manage SSH keys and Used AWS Systems Manager Session Manager to access the EC2 instance.)
     - Security Groups used as firewalls (ll outbound traffic allowed only where needed.)
     - NAT Gateway configuration (private subnet uses a NAT Gateway to download packages securely without being publicly exposed.)
     - Host Security (Used an official Ubuntu AMI (ami-0fc5d935ebf8bc3bc) instead of an unknown custom image.)
     - Secrets Management (No secrets were hardcoded into Terraform files)
     - Infrastructure as Code (Followed modular file separation (main.tf, ec2.tf, variables.tf, outputs.tf)

##  I Followed Core infrastructure security best practices:
Secure networking
Secure IAM
Secure access
Monitoring enabled
Reproducible, auditable code




##  Author

**Kishore Bandaru**  
  DevOps Engineer | DevSecOps Enthusiast  
 Email: kishorebandaru002@gmail.com  
 GitHub: [@Kishorebandaru002](https://github.com/Kishorebandaru002)  
 
