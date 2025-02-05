variable "AWS_ACCESS_KEY" {

  description = "AWS Access Key"
  type        = string

}

variable "AWS_SECRET_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}
variable "VPC_CIDR" {
  description = "CIDR block for the VPC"
  type        = string

}
variable "region" {
  description = "Region to deploy the resources"
  type        = string
  default     = "ap-south-1"

}


variable "SUB1_CIDR" {
  description = "CIDR block for the subnet 1"
  type        = string

}

variable "SUB2_CIDR" {
  description = "CIDR block for the subnet 2"
  type        = string

}

variable "SUB3_CIDR" {
  description = "CIDR block for the subnet 3"
  type        = string


}

variable "SUB4_CIDR" {
  description = "CIDR block for the subnet 3"
  type        = string


}


variable "SUB5_CIDR" {
  description = "CIDR block for the subnet 3"
  type        = string


}

variable "SUB6_CIDR" {
  description = "CIDR block for the subnet 3"
  type        = string
}


variable "zone1" {
  description = "Availability zone for subnet 1"
  type        = string


}

variable "zone2" {
  description = "Availability zone for subnet 2"
  type        = string

}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string
  default     = "ami-053b12d3152c0cc71"

}

variable "size" {
  description = "Size of the instance"
  type        = string
  default     = "t2.micro"

}






# Loadbalancer variables



variable "lb_name" {
  description = "The name of the load balancer"
  type        = string

}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}
variable "target_group_port" {
  description = "The port on which the targets receive traffic"
  type        = number

}
variable "target_group_protocol" {
  description = "The protocol to use for routing traffic to the targets"
  type        = string


}

variable "mysql_username" {
  description = "The username for the MySQL database"
  type        = string

}

variable "mysql_password" {
  description = "The password for the MySQL database"
  type        = string

}
variable "mysql_db_name" {

  description = "The password for the MySQL database"
  type        = string

}
variable "mysql_username_replica" {
  description = "The username for the MySQL database replica"
  type        = string

}

variable "mysql_password_replica" {

  description = "The password for the MySQL database replica"
  type        = string
}
variable "mysql_db_name_replica" {
  description = "The password for the MySQL database replica"
  type        = string

}