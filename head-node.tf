resource "digitalocean_droplet" "head_node" {
  image = "ubuntu-18-04-x64"
  name = "ceph-lab-${var.lab_name}-head-node"
  size = "s-2vcpu-4gb"
  region = "${var.region}"
  ssh_keys = [
    "${digitalocean_ssh_key.ceph_lab.id}"
  ]
  private_networking = true

  connection {
    type = "ssh"
    private_key = "${var.ssh_priv_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get -y install python",
    ]
  }

  provisioner "ansible" {
    plays = {
      playbook = "ansible/head-node.yml"
      groups = ["head-node"]
      extra_vars {
        ssh_priv_key = "${var.ssh_priv_key}"
        ssh_pub_key = "${var.ssh_pub_key}"
        paddles_node_ip = "${digitalocean_droplet.paddles_pulpito.ipv4_address_private}"
        lab_domain = "${var.lab_name}"
      }
    }

    local = "yes"
  }
}
