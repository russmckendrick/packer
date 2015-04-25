#!/bin/bash -eux

# Install some basics and update

<<<<<<< HEAD:CentOS7/scripts/base.sh
yum install -y wget nfs-utils rpcbind git vim-enhanced vim-common bzip2 net-tools perl
=======
yum install -y wget nfs-utils rpcbind git vim-enhanced vim-common mariadb
>>>>>>> origin/master:packer-centos-7-docker/provisioners/00-base.sh

systemctl enable rpcbind
systemctl enable nfs-lock
systemctl enable nfs-idmap

yum update -y

# update root certs
wget -O/etc/pki/tls/certs/ca-bundle.crt http://curl.haxx.se/ca/cacert.pem

# Reboot to make sure Kernel is up-to-date

reboot
sleep 60