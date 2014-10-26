#!/bin/bash -eux

# Docker

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
curl -L https://github.com/docker/fig/releases/download/1.0.0/fig-`uname -s`-`uname -m` > /usr/local/bin/fig; chmod +x /usr/local/bin/fig
/usr/local/bin/fig --version

# Pull down the NGINX Route imgage
docker pull russmckendrick/nginx-proxy

# Add the systemd service file
cat >> /usr/lib/systemd/system/docker-nginx-router.service << CONTENT
[Unit]
Description=NGINX Router
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
ExecStartPre=-/usr/bin/docker kill router
ExecStartPre=-/usr/bin/docker rm router
ExecStart=/usr/bin/docker run -p 80:80 --name="router" -v /var/run/docker.sock:/tmp/docker.sock -t russmckendrick/nginx-proxy
ExecStop=-/usr/bin/docker stop router

[Install]
WantedBy=multi-user.target
CONTENT

# Start the NGINX router as a service
systemctl enable docker-nginx-router
systemctl start docker-nginx-router