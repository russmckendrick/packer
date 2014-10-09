#!/bin/sh

set -e

# docker

# Install the latest version of Docker
echo "[goldmann-docker-io]
name=Copr repo for docker-io owned by goldmann
baseurl=http://copr-be.cloud.fedoraproject.org/results/goldmann/docker-io/epel-7-x86_64/
skip_if_unavailable=True
gpgcheck=0
enabled=1" > /etc/yum.repos.d/docker.repo
yum remove -y docker > /dev/null 2>&1
yum install -y docker-io > /dev/null 2>&1
systemctl enable docker > /dev/null 2>&1
systemctl start docker > /dev/null 2>&1
docker -v
systemctl status docker

# Add the vagrant user to the docker group
usermod -a -G docker vagrant

# Install NSEnter & Remove imgage
docker run --rm jpetazzo/nsenter cat /nsenter > /usr/local/bin/nsenter
chmod 755 /usr/local/bin/nsenter
curl -o /usr/local/bin/docker-enter https://raw.githubusercontent.com/jpetazzo/nsenter/master/docker-enter 
chmod 755 /usr/local/bin/docker-enter
nsenter -V
docker rmi jpetazzo/nsenter

# Install Fig
curl -L https://github.com/docker/fig/releases/download/0.5.2/linux > /usr/local/bin/fig
chmod 755 /usr/local/bin/fig
/usr/local/bin/fig --version