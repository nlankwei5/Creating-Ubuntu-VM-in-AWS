#!/bin/bash 

#Check if AWS is installed. if not install it 

if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Installing..."
    sudo apt-get update 
    sudo apt install -y awscli
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI installation failed. Exiting."
        exit 1
    fi
fi

#Configure and Input your AWS crednetials

aws configure 

#Launch the EC2 instance preferrably Ubuntu VM 
read -p "Enter the AMI Image ID: " image_id
read -p "Enter your Key Pair Name: " key_name
read -p "Enter the Instance Type (e.g., t2.micro): " instance_type

aws ec2 run-instances --image-id $image_id --key-name $key_name --instance-type $instance_type


#login to the Ubuntu VM 
read -p "Enter your security group ID: " security_group
read -p "Enter the path to your private SSH key file: " PRIVATE_KEY_PATH
read -p "Enter external hostname for your Ubuntu-VM: " hostname

if [ -f "$PRIVATE_KEY_PATH" ]; then
    echo "Private SSH key file found! Proceeding with login to EC2 Instance."
else
    echo "No private SSH key file found at $PRIVATE_KEY_PATH. Cannot login to EC2 Instance."
    exit 1
fi

chmod 600 "$PRIVATE_KEY_PATH"

aws ec2 authorize-security-group-ingress --group-id $security_group --port 22

ssh -i $PRIVATE_KEY_PATH ubuntu@$hostname

#Setup Lamp server 

 sudo apt update
 sudo apt upgrade
 sudo apt install apache2
 sudo systemctl start apache2
 sudo systemctl enable apache2
 sudo apt install mysql-server
 sudo apt install php libapache2-mod-php php-mysql
 sudo systemctl restart apache2


