# EC2 Instance Setup with LAMP Stack Automation (Preferrably Ubuntu VM)

This Bash script automates the setup of an Amazon EC2 instance with a LAMP stack (Linux, Apache, MySQL, PHP). The script checks for AWS CLI installation, configures the CLI, launches an EC2 instance, configures security rules, and installs the LAMP stack on the instance.

## Prerequisites

- AWS account with necessary permissions to launch EC2 instances and configure security groups.
- A key pair created in the specified AWS region.
- **Note**: This script is written for Debian-based Linux systems.

## Features

- **AWS CLI Check & Installation**: Ensures the AWS CLI is installed, or installs it if necessary.
- **Instance Launch**: Launches an EC2 instance with user-defined parameters.
- **Security Configuration**: Configures security rules to allow SSH access from the current IP.
- **LAMP Stack Installation**: Sets up Apache, MySQL, and PHP on the EC2 instance.

## Usage

1. Clone this repository or download the script.
2. Run the script:
   ```bash
   ./setup_ec2.sh
Follow the prompts to enter:

3. AMI Image ID
- Key Pair Name
- Instance Type
- AWS Region
- Security Group ID
- Path to private SSH key


4. The script will:

- Check or install AWS CLI
- Configure the AWS CLI with user credentials
- Launch an EC2 instance
- Set up security rules for SSH
- Connect via SSH to install the LAMP stack


## Example Output
```plaintext
2024-11-09 12:00:00 - AWS CLI not found. Installing...
2024-11-09 12:01:00 - Configuring AWS CLI
2024-11-09 12:02:00 - EC2 instance i-1234567890abcdef0 launched successfully.
2024-11-09 12:03:00 - EC2 instance public IP: 18.217.123.456
2024-11-09 12:04:00 - Connecting to EC2 instance via SSH...
2024-11-09 12:05:00 - Setting up LAMP server
2024-11-09 12:10:00 - LAMP setup completed on EC2 instance i-1234567890abcdef0
```

## Troubleshooting

- AWS CLI Installation Fails: Ensure your system is Debian-based and has apt-get.
- Instance Launch Fails: Verify your AWS credentials, region, and instance type.
- SSH Connection Issues: Ensure the correct private key path and security group settings.

## Kindly try it and give feedback to help make the code more efficient. Thank you