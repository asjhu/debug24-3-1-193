# Change for Demo Vars
variable "ec2-name" {
  default = "IAC-Example" # Name used when adding host to both AWS and PRA, Update for your example.
}

# AWS Vars
variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(any)
  default = {
  #  us-east-1 = "ami-0ba9883b710b05ac6" #AWS Linux 2023
    us-east-1 = "ami-08b5b3a93ed654d19" #Amazon Linux 2023
    us-west-1 = "ami-036c2987dfef867fb"
    us-east-2 = "ami-0a3c3a20c09d6f377"
  }
}

variable "instance_count" {
  default = 2
  type    = string
}

variable "username" {
  default = "aws-ami"
}

variable "aws_users" {
  type = map(any)
  default = {
    aws-ami    = "ec2-user"
    ubuntu-ami = "ubuntu"
  }
}

variable AWS_CLIENT_ID {
  type = string
}

variable AWS_CLIENT_SECRET {
  type = string
}


# SRA Vars
variable BT_CLIENT_ID {
  type = string
}

variable BT_CLIENT_SECRET {
  type = string
}

variable EPMLC-Join {
  type = string
}

#variable Entra_Tenant_Join {
#  type = map
#}
