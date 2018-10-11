resource "digitalocean_droplet" "paddles_pulpito" {
  image = "ubuntu-18-04-x64"
  name = "ceph-lab-${var.lab_name}-paddles-pulpito"
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
      playbook = {
        file_path = "ansible/paddles-pulpito.yml"
      }
      groups = ["paddles","pulpito"]
      extra_vars {
        paddles_listen_ip = "${self.ipv4_address_private}"
      }
    }
  }
}
