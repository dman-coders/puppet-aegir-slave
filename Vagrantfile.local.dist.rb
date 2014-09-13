# Stuff I don't want in source control,
# or should be customized by the user.
#
# Copy this file to rename it Vagrantfile.local.rb and then edit it.

# If using AWS-EC2, it requires you to provide some codes.
# Keys here are NOT valid at all, but included as approximations of what
# the real things look like.
module AWS_vars

    # Amazon credentials
    # ==================
    $access_key_id = "00GGHE9435P9EZJYD6R2"
    $secret_access_key = "GpB32Ee5esWdG0SSvugNsXhcX13qwd0bPHScMAe3"
    $keypair_name = "johnsAWSkeys"

    # The base box
    # ============
    # Following instructions at
    # https://help.ubuntu.com/community/EC2StartersGuide
    # From http://cloud-images.ubuntu.com/releases/precise/release/
    # I selected an ebs 64-bit instance of Ubuntu LTS 'Precise' available in ap-southeast-1 (t1-micro)
    # ubuntu-saucy-13.10-amd64-server-20140226
    #
    $ami = "ami-d44e1f86"
    $region = "ap-southeast-1"

    # If I intend to ssh (or sql) in, I need a non-default security group
    # The "default" one 'sg-2e25787c' has no ports open, so I can't even ssh in.
    # You must set yor own one up, and name it here.
    # This one is mine:
    $security_groups = ["basic ports open"]

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
