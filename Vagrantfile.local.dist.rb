# Stuff I don't want in source control,
# or should be customized by the user.
#
# COPY THIS FILE to rename it Vagrantfile.local.rb and then edit it!

module AWS_vars

    # If using AWS-EC2, it requires you to provide some codes.
    # Keys here are NOT valid at all, but included as approximations of what
    # the real things look like.

    # Amazon credentials
    # ==================
    $aws_access_key_id = "00GGHE9435P9EZJYD6R2"
    $aws_secret_access_key = "GpB32Ee5esWdG0SSvugNsXhcX13qwd0bPHScMAe3"
    # aws_keypair_name should be already available on AWS, found under AWS>EC2>Key Pairs
    $aws_keypair_name = "johnsAWSkeys"

    # The base box
    # ============
    # Following instructions at
    # https://help.ubuntu.com/community/EC2StartersGuide
    # From http://cloud-images.ubuntu.com/releases/precise/release/
    # I selected an ebs 64-bit instance of Ubuntu LTS 'Precise' available in ap-southeast-1 (t1-micro)
    # ubuntu-saucy-13.10-amd64-server-20140226
    #
    $aws_region = "ap-southeast-1"
    $aws_ami = "ami-d44e1f86"

    # OTHER REGIONS HAVE OTHER AMIs so from
    # http://cloud-images.ubuntu.com/locator/ec2/
    # when using
    # $region = "ap-southeast-2"
    # I had to instead find
    # $aws_ami = "ami-69e28d53"
    # trusty 14.04 LTS amd64 ebs


    # If I intend to ssh (or sql) in, I need a non-default security group
    # The "default" one 'sg-2e25787c' has no ports open, so I can't even ssh in.
    # You must set your own one up, and name it here.
    # This one is mine:
    $aws_security_groups = ["basic ports open"]
    # You must create and configure your own one first in the AWS console, then
    # list it by name. Multiples are allowed.

    # Amazon will have given you a pem to use, and it installs that on the
    # box to let you connect to it. Where did you put that key?
    $override_ssh_private_key_path = "~/.ec2/johnsAWSkey.pem"

    # Optional.
    $override_ssh_username = "ubuntu"

end



module DIGITALOCEAN_vars

    # Parameters for digitalocean connections
    $digitalocean_client_id = "name_of_your_api_key"
    $digitalocean_token = "c297a82clongtokenusedforauthenticatingagainstdigitaloceanapiabc1"

end
