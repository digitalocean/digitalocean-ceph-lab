# digitalocean-ceph-lab

This repository contains terraform and ansible automation for setting up a
complete ceph test environment using DigitalOcean Droplets and Volumes. Once
provisioned, the environment can be used to run tests
with [teuthology](https://github.com/ceph/teuthology).

The provisioned test environment consists of:

* One node running [paddles](https://github.com/ceph/paddles)
  and [pulpito](https://github.com/ceph/pulpito), along with a dnsmasq server to
  allow the test nodes to connect to each other via names instead of by IP.
    - The paddles server listens only on the private network.
    - The pulpito server listens is available on the public network.
    - The dnsmasq server listens on all networks, and forwards requests to
      systemd-resolved, allowing resolution of names listed in /etc/hosts.
* One "head node", with teuthology installed, running the job queue and worker.
* A configurable number of test nodes (default: 10), each with a configurable
  number of volumes attached (default: 4).

The paddles/pulpito node and head node run Ubuntu 18.04. The image used for the
test nodes is configurable, defaulting to Ubuntu 14.04. Note that using a
non-Ubuntu image is unlikely to work.

Note that the ansible portion of this repository can, with appropriate inventory
files, be used on its own to set up a teuthology lab without the use of
terraform. Terraform is used simply to create and bootstrap droplets for use in
the lab environment.

## Dependencies

You will need:
* [terraform](https://www.terraform.io/)
* [ansible](https://www.ansible.com/)
* [terraform-provisioner-ansible](https://github.com/radekg/terraform-provisioner-ansible) v2.0.1 or later

The provided Dockerfile will create a container image containing all of the
above.

## Usage

Creating a lab environment takes three simple steps:

1. Create a terraform variables file containing the configuration for your lab
   setup. It should set at least the following:
    * `do_token` - A DigitalOcean API access token.
    * `lab_name` - A unique name for your lab setup. This name will be used in
      the names of resources created, allowing multiple lab setups to co-exist
      within a single DO account, and also as the `lab_domain` for teuthology.
    * `region` - The DigitalOcean region in which to create the lab setup.
    * `ssh_pub_key` and `ssh_priv_key` - An SSH keypair to use for the lab
      setup. This will be used both to connect to created droplets for
      provisioning and for the droplets to connect to each other when running
      tests. The key must not have a passphrase.
        - NOTE: Both the public and private parts of the key end up on various
          nodes in the created system. You may want to create a key specifically
          for this purpose rather than using a key that can access other
          important resources.
2. Run `terraform init` to initialize the terraform environment.
3. Run `terraform apply -var-file=<your vars file>` to set up the environment.

Once the above have been run, you should be able to access pulpito on port 8081
of the paddles/pulpito node, and submit tests as described in the next section.

If, at some point, one of your test nodes becomes unusable (e.g., due to a test
performing a bad kernel upgrade or config change), you can easily re-spin it
using terraform. For example, to re-create test node 2, you would run:

```console
$ terraform taint digitalocean_droplet.test_node.2
$ terraform apply -var-file=<your-vars-file>`
```

This will destroy the existing test node, create a new one, and configure it to
take the old node's place in the test system, including updating DNS and the
node's entry in paddles.

## Running Tests

The easiest way to submit jobs is from the head node:

1. SSH to the head node.
2. Become the teuthology user: `sudo -u teuthology -i`
3. Use `teuthology-suite` to submit jobs.

Of course, with an appropriate teuthology configuration one should also be able
to submit jobs remotely.

## Contributing

Contributions are welcome, in the form of either issues or pull requests. Plesae
see the [contribution guidelines](CONTRIBUTING.md) for details.

## License

Copyright 2018 DigitalOcean

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
