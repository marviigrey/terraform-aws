This is a simple terraform script that helps to set up an aws infastructure.
This script will deplloy the following resources on an aws account that is already configured in an
IDE. Ensure you have terraform i stalled in your machine and you have an AWS account. 
Firstly you will need to create an IAM user to help authenticate terraform access into your console.
you will need an IDE to perform this. I strongly recommend VScode but another option is using aws cloud9
which have all resources needed to caarry out this task. With cloud9 you don't need to install terraform
because it is already installed, and the aws account used in cloud9 is already configured and 
authenticated.

The main.tf file in this directory will carry out the following task:

  1. create a VPC.
  2. create a subnet,internet-gateway and route-table.
  3. create a route table association to the previously created subnet.
  4. An EC2 security group for our instance.
  5. A link to our key pair file.
  6. An EC2instance created with ami specified in our datasource file.
  7. An ebs root volume of 10GB.
     
The datasource file holds a reference to the AMI used to create our EC2-instance which consist of:
  1. data-source name.
  2. AMI-owner-ID.
  3. The AMI name.

The provider.tf shows the list of providers we will use in the setup but we only have the AWS as our 
provider and authentication profile, we must ensure that the AWS tool kit extension is installed 
inorder to give our account access to terraform.
