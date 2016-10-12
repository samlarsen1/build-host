echo
echo "Running startup shell"
sudo apt-get update  > /dev/null

# Docker install
#  Source: https://docs.docker.com/engine/installation/linux/ubuntulinux/
echo
echo "Installing docker"
# Update apt sources
echo " - updating apt sources"
sudo apt-get install -y apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list
sudo apt-get update  > /dev/null
sudo apt-get purge lxc-docker
# Install extra kernel packages
echo " - installing extra kernel packages"
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
# Install docker
echo " - installing docker"
sudo apt-get update   > /dev/null
sudo apt-get install docker-engine  > /dev/null
echo " - starting docker daemon"
sudo service docker start

echo
echo "Installing NPM"
sudo apt-get install -y npm  > /dev/null

echo
echo "Installing htop"
sudo apt-get install -y htop

echo "Complete"