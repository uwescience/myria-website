---
layout: default
title: Amazon Cloud Deployment
group: "docs"
weight: 0
section: 2
---
# Myria Cloud Deployment
In this section, we describe how to use Ansible in order to deploy Myria on EC2.

## Setting up a Myria cluster on EC2

Ansible is a configuration management tool that manages machines via the SSH protocol. Ansible does not require a database nor any background processes to function on the control machine, and requires no software installation on the managed machines. You only need to install Ansible on a single "control machine" (which could easily be your laptop). This control machine can then managae an entire fleet of remote machines. 

For the purpose of setting up Myria on EC2, we assume you are using your laptop as the control machine. You could also use an EC2 instance as a control machine. Any modern Unix should work as the control machine, although only Ubuntu and Mac OS X have been tested. Windows is not supported, since Ansible does not support it.

### __Configure AWS account information__
Before launching instances on EC2, you will need to collect information about your AWS account. Ansible provides a number of core modules for AWS, which we use to deploy Myria on EC2. These modules require your AWS credentials ("Access Key ID" and "Secret Key") to be configured on the control machine. Here is a [link to AWS documentation](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) on how to obtain an AWS "Access Key ID" and "Secret Key". Once you have these keys, you can use them to configure the AWS CLI as described in the next step. If you are using an IAM user account, you must have the following permissions to successfully install Myria: `ec2:CreateKeyPair`, `ec2:DescribeKeyPairs`, `ec2:RunInstances`, `ec2:DescribeInstances`, `ec2:DescribeInstanceStatus`.

### __Install and Configure the AWS CLI__
Follow the instructions in the [AWS CLI documentation](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) to install the AWS CLI and configure it with the AWS credentials you obtained from the previous step.

### __Setting up Ansible on a control machine__
To ease the installation of Ansible along with its dependencies, we created a `myria-deploy` script. You can view the script [here](https://raw.githubusercontent.com/uwescience/myria-ec2-ansible/master/myria-deploy). You do not need to install Ansible before running the `myria-deploy` script, since the script will install it for you. 

**Optional:** In case you have issues with the script's Ansible installation, you can install it yourself and the script will use your installation. Follow the Ansible installation [instructions]( http://docs.ansible.com/ansible/intro_installation.html#installing-the-control-machine, "Installation"). If your control machine is a Mac, the preferred method of installation is via `pip` ([instructions]( http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip )). You can also use your native package manager (e.g., `brew` on a Mac, `apt-get` on Debian/Ubuntu, `yum` on Red Hat/CentOS) to install Ansible. In the past, El Capitan users have reported that `sudo pip install` with the system Python installation fails with filesystem permission errors, so using a package manager like Homebrew is recommended on El Capitan.


### __Deploy your Myria cluster__
Run the wrapper script `myria-deploy`, which will check for missing dependencies, launch EC2 instances using your AWS credentials, and deploy Myria on the EC2 instances:

```
./myria-deploy --verbose
```

To see a list of all options, run

```
./myria-deploy --help
```
When the `myria-deploy` script has successfully deployed Myria, it will print the URL of the `myria-web` instance running on the cluster to the console. You can point your browser to this URL in order to create and run queries via the query editor, view query plans in graphical and JSON form, profile running queries, and browse datasets and historical queries. You can read more about `myria-web` [here](http://myria.cs.washington.edu/docs/myria-web/index.html).
