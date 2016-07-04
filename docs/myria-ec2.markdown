---
layout: default
title: Myria Cloud Deployment
group: "docs"
weight: 2
section: 1

---
# Myria Cloud Deployment
In this section, we describe how to deploy Myria on the [Amazon EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) cloud computing service.

## Setting up a Myria cluster on EC2

For the purpose of setting up Myria on EC2, we assume you are using your own computer as the "control machine". (You could also use an EC2 instance as a control machine.) Any modern Unix should work as the control machine, although only Ubuntu Linux and Mac OS X have been tested. Windows is not supported, since our configuration management system, Ansible, does not support it.

### __Configure AWS account information__
Before launching instances on EC2, you will need to collect information about your Amazon Web Services (AWS) account. Here is the [AWS documentation](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) on how to obtain AWS security credentials. Once you have these credentials, in the next step you will configure them for deploying your Myria cluster. If you are using an IAM user account, you must have the following permissions to successfully install Myria: `ec2:CreateKeyPair`, `ec2:DescribeKeyPairs`, `ec2:RunInstances`, `ec2:DescribeInstances`, `ec2:DescribeInstanceStatus`.

### __Install and Configure the AWS CLI__
Follow the instructions in the [AWS documentation](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) to install the AWS Command-Line Interface (CLI) and configure it with the AWS credentials you obtained in the previous step. If you [configure named profiles](http://docs.aws.amazon.com/cli/latest/reference/configure/) with different credentials, you can refer to them with the `--profile` option to `myria-cluster`.

### __Install System Dependencies__
The `myria-cluster` Python package has some non-Python dependencies that you'll need to install before you can install `myria-cluster`. On Mac OS X, you should only need to install the Xcode command-line tools:

```
xcode-select --install
```
On Ubuntu, you should install the following packages:

```
sudo apt-get install git build-essential libssl-dev libffi-dev python-dev python-pip
```

### __Install the `myria-cluster` package__
[`myria-cluster`](https://github.com/uwescience/myria-ec2-ansible) is a Python package (installable via `pip`) that provides a command-line interface to manage Myria clusters on EC2. To install, just type

```
pip install myria-cluster
```

If you're an Anaconda user, you may need to install `pip` first:

```
conda create -n myria pip
source activate myria
pip install myria-cluster
```

If you're not installing from within a Python virtual environment (`virtualenv` or `conda create`), you may need to run the preceding commands under `sudo`.

After the `myria-cluster` package has been installed, you can simply type

```
myria-cluster --help
```

to see all commands:

```
myria-cluster --help

Usage: myria-cluster [OPTIONS] COMMAND [ARGS]...

Options:
  --version   Show the version and exit.
  -h, --help  Show this message and exit.

Commands:
  create
  destroy
  list
  start
  stop
```

You can type `myria-cluster <command> --help` to see detailed usage for any command:

```
myria-cluster create --help

Usage: myria-cluster create [OPTIONS] CLUSTER_NAME

Options:
  -v, --verbose
  --profile TEXT                 Boto profile used to launch your cluster
  --region TEXT                  AWS region to launch your cluster in
                                 [default: us-west-2]
  --zone TEXT                    AWS availability zone to launch your cluster
                                 in
  --key-pair TEXT                EC2 key pair used to launch your cluster
                                 [default: tdbaker-myria]
  --private-key-file TEXT        Private key file for your EC2 key pair
                                 [default: /Users/tdbaker/.ssh/tdbaker-
                                 myria_us-west-2.pem]
  --instance-type TEXT           EC2 instance type for your cluster  [default:
                                 t2.large]
  --cluster-size INTEGER         Number of EC2 instances in your cluster
                                 [default: 5]
  --ami-id TEXT                  ID of the AMI (Amazon Machine Image) used for
                                 your EC2 instances
  --subnet-id TEXT               ID of the VPC subnet in which to launch your
                                 EC2 instances
  --role TEXT                    Name of an IAM role used to launch your EC2
                                 instances
  --spot-price TEXT              Price in dollars of the maximum bid for an
                                 EC2 spot instance request
  --data-volume-size-gb INTEGER  Size of each instance's EBS data volume (used
                                 by Hadoop and PostgreSQL) in GB  [default:
                                 20]
  --worker-mem-gb FLOAT          Physical memory (in GB) reserved for each
                                 Myria worker  [default: 4.0]
  --worker-vcores INTEGER        Number of virtual CPUs reserved for each
                                 Myria worker  [default: 1]
  --node-mem-gb FLOAT            Physical memory (in GB) on each EC2 instance
                                 available for Myria processes  [default: 6.0]
  --node-vcores INTEGER          Number of virtual CPUs on each EC2 instance
                                 available for Myria processes  [default: 2]
  --workers-per-node INTEGER     Number of Myria workers per cluster node
                                 [default: 1]
  --cluster-log-level TEXT       One of OFF, FATAL, ERROR, WARN, DEBUG, TRACE,
                                 ALL, from lowest to highest level of detail
                                 [default: WARN]
  -h, --help                     Show this message and exit.
```

### __Deploy your Myria cluster__
You can launch a new Myria cluster using `myria-cluster create`:

```
myria-cluster create test-cluster --region us-west-2
```

```
Your new Myria cluster 'test-cluster' has been launched on Amazon EC2 in the 'us-west-2' region.

View Myria worker IDs and public hostnames of all nodes in this cluster (the coordinator has worker ID 0):
myria-cluster list test-cluster --region us-west-2

Stop this cluster:
myria-cluster stop test-cluster --region us-west-2

Start this cluster after stopping it:
myria-cluster start test-cluster --region us-west-2

Destroy this cluster:
myria-cluster destroy test-cluster --region us-west-2

Log into the coordinator node:
ssh -i /Users/tdbaker/.ssh/tdbaker-myria_us-west-2.pem ubuntu@ec2-54-200-61-76.us-west-2.compute.amazonaws.com

myria-web interface:
http://ec2-54-200-61-76.us-west-2.compute.amazonaws.com:8080

MyriaX REST endpoint:
http://ec2-54-200-61-76.us-west-2.compute.amazonaws.com:8753

Ganglia web interface:
http://ec2-54-200-61-76.us-west-2.compute.amazonaws.com:8090

Jupyter notebook interface:
http://ec2-54-200-61-76.us-west-2.compute.amazonaws.com:8888
```

Note that when running `myria-cluster create`, if at any time you decide to abort the deployment by pressing `Ctrl-C`, any EC2 resources that may have been created for this deployment will be automatically terminated (provided you don’t interrupt the script again). Also, if errors occur during host provisioning, provisioning will be retried up to 5 times on all hosts that failed. This will resolve most transient errors.

When `myria-cluster create` has successfully deployed a Myria cluster, it will display the URL of the `myria-web` instance running on the cluster. You can point your browser to this URL to compose and execute queries in the query editor, view query plans in graphical and JSON form, profile running queries, and browse datasets and historical queries. You can read more about `myria-web` [here](http://myria.cs.washington.edu/docs/myria-web/index.html).

You can also point your browser to the [Jupyter](http://jupyter.org/) (IPython) notebook server URL to upload and run your own Jupyter notebooks on the cluster.

You can monitor the performance of your cluster by pointing your browser to the Ganglia URL. This will allow you to monitor memory, CPU, I/O, disk space usage, and other metrics in real time as you execute your queries.

Finally, the script will display an [SSH](https://en.wikipedia.org/wiki/Secure_Shell) command to remotely log into the Myria coordinator to control the `myria` and `myria-web` services, view logs, or further configure the Myria system. The services running on the coordinator can be controlled with the usual Ubuntu commands for [Upstart](http://upstart.ubuntu.com/) services:

```
sudo stop myria
sudo start myria
sudo restart myria
sudo stop myria-web
sudo start myria-web
sudo restart myria-web
```

Logs for the `myria` and `myria-web` services can be viewed at `/var/log/upstart/myria.log` and `/var/log/upstart/myria-web.log`. Logs for the Hadoop and YARN daemons can be viewed at `/mnt/hadoop/logs`, and YARN container logs (for the Myria driver, coordinator, and workers) can be viewed at `/mnt/hadoop/logs/userlogs`.

You can save considerable costs (up to 90%) for large clusters by using [EC2 spot instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html). You configure your maximum bid price with the `--spot-price` parameter to `myria-cluster create`. (Note that you only ever actually pay the current spot price, not your maximum bid price.) If the current spot price exceeds your maximum bid price, or if the instance type you specify is not available in the quantity you specify, your instances will be terminated. In general, it’s best to use an older instance family for spot instances (for cost and availability reasons), and to specify `--zone` ([EC2 Availability Zone](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)) and `--spot-price` options to `myria-cluster create` based on [spot instance pricing history](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances-history.html). With older instance types, you’ll sometimes need to specify an AMI ([Amazon Machine Image](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)) compatible with the instance type. Here’s an example:

```
myria-cluster create spot-test --profile myria --region us-west-2 --zone us-west-2a --spot-price 0.08 --role myria-cluster --cluster-size 80 --instance-type m2.2xlarge --ami-id ami-9dbea4fc --data-volume-size-gb 80 --worker-mem-gb 24 --worker-vcores 3 --node-mem-gb 30 --node-vcores 4
```

If you decide not to use spot instances, you can still save considerable cost by stopping your cluster when not in use and restarting it on demand. This avoids all compute costs, and only incurs the EBS storage cost of $0.10/GB/month. The `myria-cluster stop` and `myria-cluster start` commands leverage EC2’s ability to stop and start EBS-backed instances (essentially equivalent to a reboot but possibly on different hardware).

Note that the public hostnames of nodes in your cluster will change after you restart your cluster:


```
myria-cluster list test-cluster --region us-west-2

WORKER_ID HOST
--------- ----
0         ec2-54-200-61-76.us-west-2.compute.amazonaws.com
1         ec2-54-186-124-132.us-west-2.compute.amazonaws.com
2         ec2-54-201-149-17.us-west-2.compute.amazonaws.com

```

```
myria-cluster stop test-cluster --region us-west-2

Stopping instances i-7e2cd2a5, i-7d2cd2a6, i-7c2cd2a7
Instance i-7e2cd2a5 not stopped, retrying in 30 seconds...

Your Myria cluster 'test-cluster' in the AWS 'us-west-2' region has been successfully stopped.
You can start this cluster again by running `myria-cluster start test-cluster --region us-west-2`.
```

```
myria-cluster start test-cluster --region us-west-2

Starting instances i-7e2cd2a5, i-7d2cd2a6, i-7c2cd2a7
Instance i-7e2cd2a5 not started, retrying in 30 seconds...

Your Myria cluster 'test-cluster' in the AWS 'us-west-2' region has been successfully started.
The public hostnames of all nodes in this cluster have changed.
You can view the new values by running

myria-cluster list test-cluster --region us-west-2

(note that the new coordinator has worker ID 0).
```

```
myria-cluster list test-cluster --region us-west-2

WORKER_ID HOST
--------- ----
0         ec2-54-201-192-111.us-west-2.compute.amazonaws.com
1         ec2-54-187-52-118.us-west-2.compute.amazonaws.com
2         ec2-54-213-90-178.us-west-2.compute.amazonaws.com
```

When you're finished using your cluster, terminate the cluster using the `myria-cluster destroy` command:

```
myria-cluster destroy test-cluster --region us-west-2

Terminating instances i-7e2cd2a5, i-7d2cd2a6, i-7c2cd2a7
Deleting security group test-cluster (sg-5605f630)
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group state still converging, retrying in 5 seconds...
Security group test-cluster (sg-5605f630) successfully deleted
```
