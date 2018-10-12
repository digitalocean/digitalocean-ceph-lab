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

resource "digitalocean_volume" "test_volume" {
  region = "${var.region}"
  name = "ceph-lab-${var.lab_name}-vol-${count.index}"
  size = "${var.test_vol_size}"

  count = "${var.test_node_count * var.vols_per_test_node}"
}
locals {
  volume_ids = "${formatlist("%s", digitalocean_volume.test_volume.*.id)}"
}

resource "digitalocean_droplet" "test_node" {
  image = "${var.test_node_image}"
  name = "ceph-lab-${var.lab_name}-node-${count.index}"
  size = "s-4vcpu-8gb"
  region = "${var.region}"
  ssh_keys = [
    "${digitalocean_ssh_key.ceph_lab.id}"
  ]
  volume_ids = ["${slice(local.volume_ids, count.index*var.vols_per_test_node, count.index*var.vols_per_test_node+var.vols_per_test_node)}"]
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
        file_path = "ansible/test-node.yml"
      }
      groups = ["test-node"]
      extra_vars {
        ssh_priv_key = "${var.ssh_priv_key}"
        ssh_pub_key = "${var.ssh_pub_key}"
        paddles_node_ip = "${digitalocean_droplet.paddles_pulpito.ipv4_address_private}"
        paddles_public_ip = "${digitalocean_droplet.paddles_pulpito.ipv4_address}"
        lab_domain = "${var.lab_name}"
        node_index = "${count.index}"
      }
    }
  }

  count = "${var.test_node_count}"
}
