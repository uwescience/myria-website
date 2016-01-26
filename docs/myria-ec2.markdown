---
layout: default
title: Amazon Cloud Deployment
group: "docs"
weight: 0
section: 2
---

# Deploying Myria on the Amazon EC2 Cloud

Myria supports automatically deploying Myria to a cluster through the Amazon EC2 service. To do this, you must have an [Amazon EC2](http://aws.amazon.com/ec2/) account.

## Installation

Ansible is a configuration management tool that manages machines over the SSH protocol.  Once Ansible is installed, it will not add a database, and there will be no daemons to start or keep running. You only need to install it on one machine (which could easily be a laptop) and it can manage an entire fleet of remote machines from that central point.
For the purposes of setting up MyriaX on EC2, we assume you are using your laptop as the 'Control Machine'. You could set it up on a EC2 instance for managing your EC2 deployed cluster as well.

*  __Setting up Ansible on Control Machine__
   Ansible documentation provided details on [installation]( http://docs.ansible.com/ansible/intro_installation.html#installing-     the-control-machine, "Installation").
   If your control machine is a Mac, the preferred way of installation is via pip. [Install via pip]( http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip).

*  __AWS account information__
   Ansible provides a number of core modules for AWS. We use several of these modules to setup MyriaX on AWS. The requirements for this are minimal.
   Authentication with the AWS-related modules is handled by either specifying your access and secret key as ENV variables or module arguments. You need access key ID and secret for AWS. Here is a [link to AWS documentation](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html), on how to get the access key and secret. Once you have these values, set them up as ENV variables:

    ```
    export AWS_ACCESS_KEY_ID='AK123'
    export AWS_SECRET_ACCESS_KEY='abc123'
    ```

*  __AWS keypair__
   You will need a keypair to provision EC2 instances. If you do not have a keypair, [create one now](http://docs.aws.amazon.com/gettingstarted/latest/wah/getting-started-prereq.html#create-a-key-pair).  Download the `.pem` file to your control machine. Using an SSH agent is the best way to authenticate with your end nodes, as this alleviates the need to copy your `.pem` files around. You can ssh-add your ec2 keypair with the following command:

    ```ssh-add ~/.ssh/keypair.pem```


*  __Get the Ansible Playbook__
   Get the ansible scripts from git by cloning `https://github.com/parmitam/myria-ec2-ansible.git`

*  __Deploy__
   Run the ansibleplaybook with the following command:
   ```
   ansible-playbook myria.yml "-e KEY_NAME=__<your keypair name>__"
   ```


#### Ansible Inventory Error

In case Ansible complains that there is no inventory/hosts file, follow these steps (tested on Linux Arch):

- Download the two files at:
  - https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.py
  - https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/ec2.ini
- Place them in the ansible configuration folder (`/etc/ansible`).
- Make the python script executable (`chmod +x ec2.py`)
- When deploying the Ansible playbook add `-i /etc/ansible/ec2.py` to the launch command:

```
ansible-playbook nmyria.yml "-e KEY_NAME=__your keypair name__" -i /etc/ansible/ec2.py
```

## Terminating the cluster

To terminate the cluster go to the AWS Management Console. Make sure you select the region where the instances launched. Click on the running instances, click on "Actions", hover over "Instance State" and select "Terminate". 
