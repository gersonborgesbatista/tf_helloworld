provider "aws" {
  profile    = "default"
  region     = "us-west-2"
}

resource "aws_instance" "helloworld" {
    ami = "ami-0cf6f5c8a62fa5da6"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
                #! /bin/bash
                sudo yum update
                sudo yum install -y httpd
                sudo chkconfig httpd on
                sudo service httpd start
                echo "<h1>hello world</h1>" | sudo tee /var/www/html/index.html
                EOF

    tags = {
        Name = "terraform-helloworld"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-helloworld-instance"
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}