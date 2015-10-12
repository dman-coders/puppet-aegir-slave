#!/bin/bash
# Assume we are running as root

export PROJECTNAME="aegir-slave"

# This often complains on a new machine
sudo locale-gen en_US.UTF-8
sudo sh -c "echo 'LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8' >> /etc/environment"
sudo dpkg-reconfigure locales

export HOSTNAME=$PROJECTNAME
sudo sh -c "echo $HOSTNAME > /etc/hostname"
sudo sh -c "echo '127.0.1.1 $HOSTNAME' >> /etc/hosts"

