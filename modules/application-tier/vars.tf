variable "vpc_id" {
    description = "The VPC ID in AWS"
  
}

variable "name" {
  description = "Name to be used for tags"
}

variable "route_table_id" {
    description = "the ID of the route table"
}

variable "user_data" {
    description = "the user's data"  
}

variable "ami_id" {
  description = "The ID of the AMI"
}

variable "cidr_block" {
    description = "CIDR block of tier subnet"
  
}

variable "map_public_ip_on_launch" {
    default = false
    description = "for assignment of public ips for instances launched into subnet"
  
}

variable "ingress" {
    type = list
    description = "rules that allow inbound connections to reach endpoints defined in backend"  
}