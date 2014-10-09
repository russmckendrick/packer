#!/bin/bash		

# Saves ~25M
yum -y remove kernel-devel

# Clean cache
yum clean all

# Clean out all of the caching dirs
rm -rf /var/cache/* /usr/share/doc/*

# Clean up unused disk space so compressed image is smaller.
cat /dev/zero > /tmp/zero.fill
rm /tmp/zero.fill

# Sync to ensure that the delete completes before this moves on.
sync
sync
sync