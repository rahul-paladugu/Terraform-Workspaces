resource "aws_instance" "roboshop" {
  ami = data.aws_ami.rahul-practice.id #used the data module to find the ami_id.
  instance_type = lookup(var.instance_type, terraform.workspace) #Lookup function used to find the key value of environment
  vpc_security_group_ids = [aws_security_group.allow-network.id] #picked from the SG created below
  tags = local.ec2_tags #Attached the tags hardcoded in locals.tf
}

resource "aws_security_group" "allow-network" {
    name = local.sg_name
    dynamic "egress" {  #Dynamic block is used to iterate the block of content and updated the port numbers.
      for_each = toset(var.network_ports)
      content {
        from_port = egress.value
        to_port = egress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    dynamic "ingress" { #Dynamic block is used to iterate the block of content and updated the port numbers.
      for_each = toset(var.network_ports)
      content {
        from_port = ingress.value
        to_port = ingress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    tags = local.sg_tags
}

resource "aws_route53_record" "dns-records" {
    zone_id = data.aws_route53_zone.roboshop.zone_id #used the data module to find the zone id.
    name = local.dns_record
    type = "A"
    ttl = 1
    records = [aws_instance.roboshop.private_ip]
    allow_overwrite = true #To delete any existing records
  
}