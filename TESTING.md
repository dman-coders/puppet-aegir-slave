During development, for ongoing troubleshooting, we would
* log into the running instance ( vagrant ssh ) from the project folder.
* cd /vagrant - where we find the contents of the project folder mounted on the VM
* "sudo puppet apply manifests" will try to run all the pp files in that folder.

However, also need to set the puppet modulepath.
Check what it is right now by going "puppet config print modulepath"
If it is NOT /vagrant/modules then

    sudo puppet apply --modulepath=/vagrant/modules /vagrant/manifests

As we are just including a whole folder, there is no way to influence
install order to produce dependencies
- MUST use puppet syntax for requirements and let its logic figure out
dependencies on its own.
