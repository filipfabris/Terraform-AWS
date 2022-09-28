provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = var.region
}

#Create aws security group
resource "aws_security_group" "test_security_group" {
    name = "nova"
    description = "Created via Terraform"

    #In traffic
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #Out traffic, allow all -- SECURITY, change
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

#Create aws instance for haproxy
resource "aws_instance" "haproxy_load_balancer" {
    security_groups = ["${aws_security_group.test_security_group.name}"]
    instance_type = "${var.load_balancer_instance_type}"
    key_name = "${var.aws_key_name}"
    ami = "${var.load_balancer_ami}"

    # The connection block tells our provisioner how to
    # communicate with the resource (instance)
    connection {
        user = "ec2-user"
        private_key = "${var.aws_pem_key_file_path}"
        host = self.public_ip
    }

    count = 1

    # provisioner "file" {
    #     source = "tf-remote-haproxy-script.sh"
    #     destination = "/tmp/tf-remote-haproxy-script.sh"
    # }

    # provisioner "remote-exec" {
    #     # some `sleep` might be needed to prevent i/o timeout here?
    #     inline = [
    #       "sleep 420",
    #       "chmod +x /tmp/tf-remote-haproxy-script.sh",
    #       "sudo /tmp/tf-remote-haproxy-script.sh"
    #     ]
    # }
}

#Create aws instance for apache web
resource "aws_instance" "web" {
    security_groups = ["${aws_security_group.test_security_group.name}"]
    key_name = "${var.aws_key_name}"
    instance_type = "${var.web_instance_type}"

    ami = "${var.web_ami}"

    connection {
        user = "ec2-user"  #Za OS instancu je drugaciji default user, nije moguc root login
        private_key = file(var.aws_pem_key_file_path)
        host = self.public_ip
    }

    #count = "${var.desired_web_server_count}"
    #count = 0
}