variable "instance_type" {
  default = {
    dev = "t3.micro"
    prod = "t3.small"
  }
}

variable "project" {
  default = "roboshop"
}

variable "network_ports" {
    default = [22, 80, 443]
}