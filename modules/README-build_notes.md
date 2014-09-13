

I had so much trouble with ruby (vagrant/bundler/gems yadda yadda fuck)
being out of date every single tim I want to use them!

After breaking my native OS and environment so many times,
I'll just use a VM dedicated to being the puppet builder -
so that I know there is only one set of dependencies for my shell environment,
and the commands I ran last month will hopefully work next month.

This will only work for running if using remote hosts for provisioning (AWS etc)
clearly it's no fun running vagrant->virtualbox inside a VM,

So - the invocations should be like:

    cd ~/vagrant/projects/
    git clone git@github.com:dman-coders/puppet-aegir-slave.git
    cd puppet-aegir-slave
    vagrant up --provider=aws

The first time, this will have to do its own vagrant box add,
to download a vm image) - so may take a while.
However, both the aws and the digitalocean 'boxes' are just stubs.


