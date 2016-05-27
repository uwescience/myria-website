---
layout: default
title: Myria Amazon Cloud Deployment
group: "docs"
weight: 2
section: 1
---
# Myria Cloud Deployment
In this section, we describe how to deploy Myria on EC2.

## Setting up a Myria cluster on EC2

For the purpose of setting up Myria on EC2, we assume you are using your own computer as the "control machine". (You could also use an EC2 instance as a control machine.) Any modern Unix should work as the control machine, although only Ubuntu and Mac OS X have been tested. Windows is not supported, since our configuration management system, Ansible, does not support it.

### __Configure AWS account information__
Before launching instances on EC2, you will need to collect information about your AWS account. Here is the [AWS documentation](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) on how to obtain AWS security credentials. Once you have these credentials, you can use them to configure the AWS CLI, as described in the next step. If you are using an IAM user account, you must have the following permissions to successfully install Myria: `ec2:CreateKeyPair`, `ec2:DescribeKeyPairs`, `ec2:RunInstances`, `ec2:DescribeInstances`, `ec2:DescribeInstanceStatus`.

### __Install and Configure the AWS CLI__
Follow the instructions in the [AWS CLI documentation](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) to install the AWS CLI and configure it with the AWS credentials you obtained from the previous step.

### __Deploy your Myria cluster__
Run the wrapper script [`myria-deploy`](https://raw.githubusercontent.com/uwescience/myria-ec2-ansible/master/myria-deploy), which will check for missing dependencies, launch EC2 instances using your AWS credentials, and deploy Myria on the EC2 instances:

```
./myria-deploy --verbose
```

To see a list of all options, run

```
./myria-deploy --help
```
When the `myria-deploy` script has successfully deployed Myria, it will display the URL of the `myria-web` instance running on the cluster. You can point your browser to this URL in order to compose and execute queries in the query editor, view query plans in graphical and JSON form, profile running queries, and browse datasets and historical queries. You can read more about `myria-web` [here](http://myria.cs.washington.edu/docs/myria-web/index.html). The script will also display an SSH command to remotely log into the Myria coordinator to control the `myria` and `myria-web` services, view logs, or further configure the Myria system. The services running on the coordinator can be controlled with the usual Ubuntu commands for Upstart services:

```
sudo stop myria
sudo start myria
sudo restart myria
sudo stop myria-web
sudo start myria-web
sudo restart myria-web
```

Logs for the `myria` and `myria-web` services can be viewed at `/var/log/upstart/myria.log` and `/var/log/upstart/myria-web.log`. Logs for the Hadoop and YARN daemons can be viewed at `/opt/hadoop/logs`, and YARN container logs (for the Myria driver, coordinator, and workers) can be viewed at `/opt/hadoop/logs/userlogs`.
