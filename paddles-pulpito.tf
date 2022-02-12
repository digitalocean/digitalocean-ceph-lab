# Copyright 2018 DigitalOcean
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    host = "${self.ipv4_address}"
    type = "ssh"
    private_key = "${var.ssh_priv_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo killall apt apt-get",
      "apt-get update",
      "apt-get -y install python",
    ]
  }

  provisioner "ansible" {
    plays {
      playbook {
        file_path = "ansible/paddles-pulpito.yml"
      }
      groups = ["paddles","pulpito"]
      extra_vars = {
        paddles_listen_ip = "${self.ipv4_address_private}"
      }
    }
  }
}
