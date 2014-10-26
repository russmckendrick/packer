#!/bin/bash -eux

# Install some basics and update

yum install -y wget nfs-server rpcbind git vim-common vim-enhanced && yum update -y

# Enable NFS

systemctl enable nfs-server.service
systemctl enable rpcbind.service

# update root certs
wget -O/etc/pki/tls/certs/ca-bundle.crt http://curl.haxx.se/ca/cacert.pem

# Reboot to make sure Kernel is up-to-date

reboot
sleep 60