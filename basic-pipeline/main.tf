provider "aws" {
    region     = "ap-south-1"
    access_key = "x"
    secret_key = "x+"
}
resource "aws_instance" "instance-1" {
    ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"
    count = "1"
    security_groups = ["iloveaws23112024"]
    key_name = "ilovwaws15112024"
    user_data = file("server-script.sh")
    tags = {
      Name = "versioning"
    }
}
