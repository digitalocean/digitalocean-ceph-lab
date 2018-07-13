provider "digitalocean" {
  token = "${var.do_token}"
  version = "~> 0.1"
}

variable "do_token" {}
