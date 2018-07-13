resource "digitalocean_ssh_key" "ceph_lab" {
  name = "ceph-lab-${var.lab_name}"
  public_key = "${var.ssh_pub_key}"
}
