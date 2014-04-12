#!/bin/bash
# http://blog.doismellburning.co.uk/2013/01/19/upgrading-puppet-in-vagrant-boxes/

sudo apt-get install --yes lsb-release
DISTRIB_CODENAME=$(lsb_release --codename --short)
DEB="puppetlabs-release-${DISTRIB_CODENAME}.deb"
DEB_PROVIDES="/etc/apt/sources.list.d/puppetlabs.list" # Assume that this file's existence means we have the Puppet Labs repo added

if [ ! -e $DEB_PROVIDES ]
then
    # Print statement useful for debugging, but automated runs of this will interpret any output as an error
    # print "Could not find $DEB_PROVIDES - fetching and installing $DEB"
    wget -q http://apt.puppetlabs.com/$DEB
    sudo dpkg -i $DEB
fi

# Only run the apt update if it looks out of date - like a new repo has been added.
# This is such a crappy hacky check ... stolen from stackoverflow.
if [ ! -f /var/cache/apt/pkgcache.bin ] || ` /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null ` ; then
  sudo apt-get update
  sudo apt-get autoremove
fi

sudo apt-get install --yes puppet
