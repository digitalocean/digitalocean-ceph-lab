variable "lab_name" {}
variable "region" {}
variable "ssh_pub_key" {}
variable "ssh_priv_key" {}
variable "test_node_image" {
  default = "ubuntu-14-04-x64"
}
variable "test_node_count" {
  default = 10
}
variable "vols_per_test_node" {
  default = 4
}
variable "test_vol_size" {
  default = 10
}
