#!/bin/bash -eux

# Docker

echo "========================================================================"
echo "Docker installation"
echo ""
echo "This script will remove the vendor version of Docker and install the more"
echo "up-to-date pre-compiled binaries supplied by Docker"
echo ""
echo "========================================================================"
echo ""
echo "=> Removing vendor installation of Docker ..."
yum remove -y docker > /dev/null 2>&1
echo "=> Done!"
echo "=> Installing Docker & Fig binaries ..."
curl -L https://get.docker.com/builds/Linux/x86_64/docker-latest > /usr/bin/docker; chmod +x /usr/bin/docker
curl -L https://github.com/docker/fig/releases/download/1.0.0/fig-`uname -s`-`uname -m` > /usr/local/bin/fig; chmod +x /usr/local/bin/fig
curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.service > /usr/lib/systemd/system/docker.service
curl -L https://raw.githubusercontent.com/docker/docker/master/contrib/init/systemd/docker.socket > /usr/lib/systemd/system/docker.socket
echo "=> Enabling & starting Docker ..."
systemctl enable docker > /dev/null 2>&1
systemctl start docker > /dev/null 2>&1
echo "=> Done!"
echo "========================================================================"
echo "The latest Docker binaries from 'docker.com' have been installed and configured:"
echo ""
docker -v
echo ""
fig --version
echo ""
systemctl status docker
echo ""
echo "========================================================================"

# Add the vagrant user to the docker group
usermod -a -G docker vagrant

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

# Add the mysql connect script
curl -L https://j.mp/1nJOJ5V > /usr/local/bin/connect
chmod 755 /usr/local/bin/connect

# Add the toolbox script
curl -L https://gist.githubusercontent.com/russmckendrick/553505f7d03a06fe9e67/raw/f915323ceaddfbcedead88ecf5442f63fa5c8c04/toolbox.sh > /usr/local/bin/toolbox
chmod 755 /usr/local/bin/toolbox