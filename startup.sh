
export DEBIAN_FRONTEND=noninteractive

echo "Running startup shell"
sudo apt-get update  > /dev/null

# Docker install
#  Source: https://docs.docker.com/engine/installation/linux/ubuntulinux/
echo "Installing docker"
# Update apt sources
echo " - updating apt sources"
sudo apt-get install -y apt-transport-https ca-certificates  > /dev/null
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D  > /dev/null
sudo echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list
sudo apt-get update  > /dev/null
sudo apt-get purge lxc-docker  > /dev/null
# Install extra kernel packages
echo " - installing extra kernel packages"
sudo apt-get install -y linux-headers-$(uname -r) > /dev/null
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual  > /dev/null
# Install docker
echo " - installing docker"
sudo apt-get update  > /dev/null
sudo apt-get install -y docker-engine  > /dev/null
echo " - starting docker daemon"
sudo service docker start
sudo docker run hello-world
echo " - Config docker group/user"
sudo groupadd docker
sudo usermod -aG docker vagrant
sudo systemctl enable docker

echo "Installing Ansible"
sudo apt-get install -y ansible  > /dev/null

echo "Installing NPM"
sudo apt-get install -y npm  > /dev/null

echo "Installing htop"
sudo apt-get install -y htop

echo "Complete"