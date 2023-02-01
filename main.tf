provider "aws" {
  region="us-west-2"
}

# Creating our VPC
# my number is 10

resource "aws_vpc" "MehdiRizvi-app-deployment-vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "MehdiRizvi-app-deployment-vpc"
  }
}

resource "aws_internet_gateway" "MehdiRizvi-ig" {
    vpc_id = "${aws_vpc.MehdiRizvi-app-deployment-vpc.id}"

    tags = {
        Name = "MehdiRizvi-ig"
    }
}

resource "aws_route_table" "MehdiRizvi-rt" {
  vpc_id = "${aws_vpc.MehdiRizvi-app-deployment-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.MehdiRizvi-ig.id}"
  }
}


module "application-tier" {
 name = "MehdiRizvi-app"
 source = "./modules/application-tier"
 vpc_id = "${aws_vpc.MehdiRizvi-app-deployment-vpc.id}"
 route_table_id = "${aws_route_table.MehdiRizvi-rt.id}"
 cidr_block = "10.10.0.0/24"
 user_data=templatefile("./scripts/app_user_data.sh", {})
 ami_id = "ami-04ddea7950cd45651"
 map_public_ip_on_launch = true

 ingress = [{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = "0.0.0.0/0"
    },{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "82.16.101.203/32"
    },{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "3.137.172.209/32"
    }
 ]
}

resource "aws_key_pair" "deployer" {
    key_name = "MehdiRizvi-awskey"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIg6ONzQBDoZjM7h2CDxgGaZcRIjc4RCbKSclwJsBU8W6/I+lBTQWx91nlRvyiewU/wMvlrlBlMiTKlOO0YijJatWPDyekS+/34/C8GTxbhOvesgkqcikxePIiLdYsyHHaXfj2IM6GIASfroCwIxTdfJHCBPnoaD+pmryvzyuSNVOBhs+9u6c5405yMIryj5FYJrjposurl/ILr9BTWkFymE8Zi6RqSlsrRsQzO+VZ80X+ZJA89pn62bQvapZk9Rkwis33Od8O7vw5k6EN8+FUFUN3XJR34wUtN6rl7FpvzwaZsKJ+Oq9jL/oNBn5/5Sb8FSKwzGph/1w+8Y55T3Pr"
}