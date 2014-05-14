To start an instance on EC2

    vagrant up --provider=aws

To stop it

    vagrant destroy

To see what's running (use the ec2 cli tools) and find its name and address.

  ec2-describe-instances

Differences:
 - does not use the apt-cacher like local virtualbox may.
 - uses a different base box.
