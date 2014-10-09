#!/bin/bash
# Base install
function die()  {
   echo "[ERROR] $1"
   exit 1
}

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
sed -i s/^SELINUX=.*/SELINUX=disabled/g /etc/selinux/config  || die "Cannot adapt SELINUX"

# Make ssh faster by not waiting on DNS
echo "UseDNS no" >> /etc/ssh/sshd_config