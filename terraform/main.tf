provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "instance-1" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"
  security_groups = ["iloveaws23112024 "]
  key_name = "ilovwaws15112024 "
  tags ={
    Name = "grafana-server"
  }
}

resource "aws_instance" "instance-2" {
  ami           = "ami-0fff1b9a61dec8a5f"
  instance_type = "t2.micro"
  security_groups = ["iloveaws23112024 "]
  key_name = "ilovwaws15112024"
  tags ={
    Name = "node-expo"
  }
}


