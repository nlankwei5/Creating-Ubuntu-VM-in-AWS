#!/bin/bash 

# Function to log messages
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    log "AWS CLI not found. Installing..."
    sudo apt-get update 
    sudo apt install -y awscli
    if ! command -v aws &> /dev/null; then
        log "AWS CLI installation failed. Exiting."
        exit 1
    fi
fi

# Configure AWS CLI
log "Configuring AWS CLI"
aws configure

# Prompt user for EC2 configuration
read -p "Enter the AMI Image ID: " image_id
read -p "Enter your Key Pair Name: " key_name
read -p "Enter the Instance Type (e.g., t2.micro): " instance_type
read -p "Enter AWS region (e.g., us-east-1): " region

# Launch the EC2 instance
instance_id=$(aws ec2 run-instances --image-id $image_id --key-name $key_name --instance-type $instance_type --region $region --query 'Instances[0].InstanceId' --output text)

if [ -z "$instance_id" ]; then
    log "Failed to launch EC2 instance. Exiting."
    exit 1
else
    log "EC2 instance $instance_id launched successfully."
fi

# Wait for the instance to initialize and fetch public IP
log "Waiting for EC2 instance to be ready..."
aws ec2 wait instance-running --instance-ids $instance_id --region $region
public_ip=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[0].Instances[0].PublicIpAddress' --output text --region $region)

if [ -z "$public_ip" ]; then
    log "Failed to retrieve the public IP address. Exiting."
    exit 1
else
    log "EC2 instance public IP: $public_ip"
fi

# Configure security group for SSH access
read -p "Enter your security group ID: " security_group
aws ec2 authorize-security-group-ingress --group-id $security_group --protocol tcp --port 22 --cidr $(curl -s https://checkip.amazonaws.com)/32 --region $region

# Connect to the instance
read -p "Enter the path to your private SSH key file: " PRIVATE_KEY_PATH

if [ -f "$PRIVATE_KEY_PATH" ]; then
    chmod 600 "$PRIVATE_KEY_PATH"
    log "Connecting to EC2 instance via SSH..."
    ssh -i $PRIVATE_KEY_PATH ubuntu@$public_ip
else
    log "No private SSH key file found at $PRIVATE_KEY_PATH. Cannot login to EC2 instance."
    exit 1
fi

# Setup LAMP stack
log "Setting up LAMP server"
ssh -i $PRIVATE_KEY_PATH ubuntu@$public_ip <<EOF
    sudo apt update && sudo apt -y upgrade
    sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
    sudo systemctl enable apache2
    sudo systemctl restart apache2
EOF

log "LAMP setup completed on EC2 instance $instance_id"

