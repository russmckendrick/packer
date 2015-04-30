#!/bin/bash -eux

# Install some basics and update

yum install -y epel-release wget

# add 'single-request-reopen' so it is included when /etc/resolv.conf is generated
echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
service network restart
echo 'Slow DNS fix applied (single-request-reopen)'

# update root certs
wget -O/etc/pki/tls/certs/ca-bundle.crt http://curl.haxx.se/ca/cacert.pem

# Reboot to make sure Kernel is up-to-date
yum update -y
reboot
sleep 60
