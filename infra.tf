resource "aws_instance" "roboshop" {
  ami = data.aws_ami.rahul-practice.id
  instance_type = lookup(var.instance_type, terraform.workspace)
  vpc_security_group_ids = [  ]
  tags = local.ec2_tags
}

resource "aws_security_group" "allow-network" {
    name = "allow-required-traffic"
    dynamic "egress" {
      for_each = toset(var.network_ports)
      content {
        from_port = egress.value
        to_port = egress.value
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    dynamic "ingress" {
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
    zone_id = data.aws_route53_zone.roboshop.zone_id
    name = local.dns_record
    type = "A"
    ttl = 1
    records = aws_instance.roboshop.secondary_private_ips
    allow_overwrite = true
  
}