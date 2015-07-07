# Packer Image Builds

## Introduction - CentOS 7

This repository provides a means to build minimal CentOS 7 boxes for both OpenStack (KVM) & VMware stacks. The focus is to:

* build production ready images
* reduce the image to the minimal required set
* do not expect any specific environment (for patch management etc)

This repository can be used to build:

* KVM images (e.g. for OpenStack)
* VMware images (e.g. for vSphere or vCloud)

CentOS 7 is the next major release with [great new features](http://wiki.centos.org/Manuals/ReleaseNotes/CentOS7).

## Requirements

The templates are only tested with [packer](http://www.packer.io/downloads.html) 0.5.2 and later.

In order to create an OVF file for use in VMware environments we use the [vagrant-vmware-ovf post-processor from gosddc](https://github.com/gosddc/packer-post-processor-vagrant-vmware-ovf) so make sure that's installed.

## Build cloud images for OpenStack

The Cloud Images are build on the following guidelines:

* Minimal Setup (installs only required base packages)
* Use XFS as default file system instead of LVM
* Configuration for network devices
* Optimized for usage with CloudInit
* No surprises

```bash
# start the installation
packer build -only=centos-7-cloud-kvm centos7.json

# shrink the image size
qemu-img convert -c -f qcow2 -O qcow2 -o cluster_size=2M output-centos-7-cloud-kvm/packer-centos-7-cloud-kvm output-centos-7-cloud-kvm/packer-centos-7-cloud-kvm.compressed.qcow2

# upload the image to openstack
glance image-create --name "CentOS 7" --container-format ovf --disk-format qcow2 --file output-centos-7-cloud-kvm/packer-centos-7-cloud-kvm.compressed.qcow2 --is-public True --progress
```

## Build images for VMware

```bash
# start the installation
packer build -only=centos-7-vmware centos7.json
```

## Meta Data Server

To ensure cloud-init works properly, you need to ensure that cloud-init is able to reach the metadata server during bootup:

```bash
route add 169.254.169.254 mask 255.255.255.255 <router-ip>
```

We recommend to configure the route in DHCP instead on the image.

## Contributors

The list of contributors can be found at: [https://github.com/russmckendrick/packer/graphs/contributors](https://github.com/russmckendrick/packer/graphs/contributors)

