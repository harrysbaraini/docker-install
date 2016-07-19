#!/bin/bash

echo "Login as sudo"
sudo su

echo "Update package information, ensure that APT works with the https method, and that CA certificates are installed."
apt-get update
apt-get install apt-transport-https ca-certificates -y

echo "Add the new GPG key."
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

echo "Create docker.list source"
touch /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list

echo "Update APT package index and purge the old repo (if it exists)"
apt-get update
apt-get purge lxc-docker

echo "Verify APT is pulling from the right directory"
apt-cache policy docker-engine

echo "Install Linux Image Extra kernal package"
apt-get install linux-image-extra-$(uname -r)

echo "Install Docker"
apt-get install docker-engine

echo "Create Docker Group and add user to it"
groupadd docker
usermod -aG docker $(whoami)

echo "Install Docker Compose"
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose

echo "DOCKER AND DOCKER COMPOSE ARE INSTALLED."
echo "RUN docker run hello-world to check if everything is ok."
echo "Log out and log in your user to have access to Docker daemon, otherwise you will need to use sudo"
echo "GONNA HAVE FUN!"
