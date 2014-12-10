To start an instance on EC2

    vagrant up --provider=aws

To stop it

    vagrant destroy

To see what's running (use the ec2 cli tools) and find its name and address.

  ec2-describe-instances

Differences:
 - does not use the apt-cacher like local virtualbox may.
 - uses a different base box.


REQUIRES vagrant-aws.
Install using

  vagrant plugin install vagrant-aws

I had trouble with this, and dependencies,
mostly because sometimes ruby had installed using sudo and sometimes not.
The error messages were helpful though.
    gem install nokogiri -v '1.6.5'
.. needed to be done with sudo for me.
