---
layout: default
title: Myria Cloud Deployment
group: "docs"
weight: 2
section: 1

---
# Myria Cloud Deployment
In this section, we describe how to deploy Myria on the [Amazon EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) cloud computing service.

## Deploying a Myria cluster on EC2

We assume you are using your own computer to deploy Myria on EC2. (You could also deploy Myria from an EC2 instance.) You should be able to deploy Myria from any modern Unix, although only Ubuntu Linux and Mac OS X have been tested. Windows is not supported, since our configuration management system, [Ansible](http://docs.ansible.com/), does not support it.

### __Verify AWS permissions and retrieve AWS security credentials__
Before you can deploy Myria on EC2, you will need to [obtain security credentials](http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html) for your AWS (Amazon Web Services) account. If you are using an IAM user account, you must have the following permissions to deploy Myria: `ec2:CreateKeyPair`, `ec2:DescribeKeyPairs`, `ec2:RunInstances`, `ec2:DescribeInstances`, `ec2:DescribeInstanceStatus`.

### __Configure AWS security credentials__
You can configure your AWS security credentials for access by `myria-cluster` in any of several ways: by installing and configuring the AWS Command-Line Interface (CLI), by installing one of the AWS SDKs (such as the `boto` Python package), by setting some environment variables, or just by letting `myria-cluster` prompt you to enter credentials (which will be saved for future use). If you wish to install the AWS Command-Line Interface (CLI), follow the instructions in the [AWS documentation](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) and configure it with the AWS credentials you obtained in the previous step. If you [configure named profiles](http://docs.aws.amazon.com/cli/latest/reference/configure/) with different credentials, you can refer to them with the `--profile` option to `myria-cluster`. If you don't want to install any AWS software, you can either let `myria-cluster` prompt you to enter credentials (if you don't mind saving them to disk), or export the following environment variables from your shell:

- `AWS_ACCESS_KEY_ID`
  The access key for your AWS account.
- `AWS_SECRET_ACCESS_KEY`
  The secret key for your AWS account.

For more information on configuring AWS security credentials, see the [`boto` documentation](http://boto3.readthedocs.io/en/latest/guide/configuration.html).

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
Installing `myria-cluster` from within a Python virtual environment (`virtualenv` or `conda create`), is _strongly_ recommended to avoid unpredictable dependency conflicts! If you're an Anaconda user, you may need to install `pip` first:

```
conda create -n myria pip
source activate myria
pip install myria-cluster
```

If you're not installing from within a Python virtual environment, you may need to run the preceding commands under `sudo`.

After the `myria-cluster` package has been installed, you can simply type

```
myria-cluster --help
```

to see all commands:

```
$ myria-cluster --help
                                                                                                                                         
Usage: myria-cluster [OPTIONS] COMMAND [ARGS]...

Options:
  --version   Show the version and exit.
  -h, --help  Show this message and exit.

Commands:
  create
  create-image
  delete-image
  destroy
  list
  list-images
  resize
  start
  stop
  update
```

You can type `myria-cluster <command> --help` to see detailed usage for any command:

```
$ myria-cluster create --help                                                                                                                                        

Usage: myria-cluster create [OPTIONS] CLUSTER_NAME

Options:
  --verbose
  --silent
  --unprovisioned                 Install required software at deployment
  --profile TEXT                  AWS credential profile used to launch your
                                  cluster
  --region TEXT                   AWS region to launch your cluster in
                                  [default: us-west-2]
  --zone TEXT                     AWS availability zone to launch your cluster
                                  in
  --key-pair TEXT                 EC2 key pair used to launch your cluster
                                  [default: tdbaker-myria]
  --private-key-file TEXT         Private key file for your EC2 key pair
                                  [default: /Users/tdbaker/.ssh/tdbaker-
                                  myria_us-west-2.pem]
  --instance-type TEXT            EC2 instance type for your cluster
                                  [default: t2.large]
  --cluster-size INTEGER RANGE    Number of EC2 instances in your cluster
                                  [default: 5]
  --ami-id TEXT                   ID of the AMI (Amazon Machine Image) used
                                  for your EC2 instances [default: ami-
                                  f5973b95]
  --subnet-id TEXT                ID of the VPC subnet in which to launch your
                                  EC2 instances
  --role TEXT                     Name of an IAM role used to launch your EC2
                                  instances
  --spot-price TEXT               Price in dollars of the maximum bid for an
                                  EC2 spot instance request
  --storage-type [ebs|local]      Type of the block device where Myria data is
                                  stored  [default: ebs]
  --data-volume-size-gb INTEGER   Size of each EBS data volume in GB [default:
                                  20]
  --data-volume-type [gp2|io1|st1|sc1]
                                  EBS data volume type: General Purpose SSD
                                  (gp2), Provisioned IOPS SSD (io1),
                                  Throughput Optimized HDD (st1), Cold HDD
                                  (sc1) [default: gp2]
  --data-volume-iops INTEGER      IOPS to provision for each EBS data volume
                                  (only applies to 'io1' volume type)
  --data-volume-count INTEGER RANGE
                                  Number of EBS data volumes to attach to this
                                  instance [default: 1]
  --driver-mem-gb FLOAT           Physical memory (in GB) reserved for Myria
                                  driver  [default: 0.5]
  --coordinator-mem-gb FLOAT      Physical memory (in GB) reserved for Myria
                                  coordinator [default: 5.4]
  --worker-mem-gb FLOAT           Physical memory (in GB) reserved for each
                                  Myria worker [default: 5.4]
  --heap-mem-fraction FLOAT       Fraction of container memory used for JVM
                                  heap  [default: 0.9]
  --coordinator-vcores INTEGER    Number of virtual CPUs reserved for Myria
                                  coordinator [default: 1]
  --worker-vcores INTEGER         Number of virtual CPUs reserved for each
                                  Myria worker [default: 1]
  --node-mem-gb FLOAT             Physical memory (in GB) on each EC2 instance
                                  available for Myria processes [default: 6.0]
  --node-vcores INTEGER           Number of virtual CPUs on each EC2 instance
                                  available for Myria processes [default: 2]
  --workers-per-node INTEGER      Number of Myria workers per cluster node
                                  [default: 1]
  --cluster-log-level [OFF|FATAL|ERROR|WARN|DEBUG|TRACE|ALL]
                                  [default: WARN]
  -h, --help                      Show this message and exit.
```

### __Deploy your Myria cluster__
You can launch a new Myria cluster using `myria-cluster create`. This command has many options, but all have reasonable default values. The only mandatory argument is the name of your cluster:

```
myria-cluster create test-cluster
```

```
Your new Myria cluster 'test-cluster' has been launched on Amazon EC2 in the 'us-west-2' region.

View the Myria worker IDs and public hostnames of all nodes in this cluster (the coordinator has worker ID 0):
myria-cluster list test-cluster --region us-west-2

View cluster configuration options:
myria-cluster list test-cluster --metadata --region us-west-2

Stop this cluster:
myria-cluster stop test-cluster --region us-west-2

Start this cluster after stopping it:
myria-cluster start test-cluster --region us-west-2

Resize this cluster (cluster size can only increase!):
myria-cluster resize test-cluster --increment 1 --region us-west-2
or
myria-cluster resize test-cluster --cluster-size 6 --region us-west-2

Update Myria software on this cluster:
myria-cluster update test-cluster --region us-west-2

Destroy this cluster:
myria-cluster destroy test-cluster --region us-west-2

Log into the coordinator node:
ssh -i /Users/me/.ssh/me-myria_us-west-2.pem ubuntu@ec2-54-202-211-221.us-west-2.compute.amazonaws.com

MyriaWeb interface:
http://ec2-54-202-211-221.us-west-2.compute.amazonaws.com:8080

MyriaX REST endpoint:
http://ec2-54-202-211-221.us-west-2.compute.amazonaws.com:8753

Ganglia web interface:
http://ec2-54-202-211-221.us-west-2.compute.amazonaws.com:8090

Jupyter notebook interface:
http://ec2-54-202-211-221.us-west-2.compute.amazonaws.com:8888

Do you want to open the MyriaWeb interface in your browser? [y/N]: y
```

Note that when running `myria-cluster create`, if at any time you decide to abort the deployment by pressing `Ctrl-C`, any EC2 resources that may have been created for this deployment will be automatically terminated. Also, if errors occur during host provisioning, provisioning will be retried up to 5 times on all hosts that failed. This will resolve most transient errors.

When `myria-cluster create` has successfully deployed a Myria cluster, it will prompt you to open the `myria-web` UI for your new cluster. You can use this UI to compose and execute queries in the query editor, view query plans in graphical and JSON form, profile running queries, and browse datasets and historical queries. You can read more about `myria-web` [here](http://myria.cs.washington.edu/docs/myria-web/index.html).

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

Logs for the `myria` and `myria-web` services can be viewed at `/var/log/upstart/myria.log` and `/var/log/upstart/myria-web.log`. Logs for the Hadoop and YARN daemons can be viewed at `/data/hadoop/logs`, and YARN container logs (for the Myria driver, coordinator, and workers) can be viewed at `/data/hadoop/logs/userlogs`.

You can view the configuration options you used to create your cluster at any time by running `myria-cluster list --metadata`:

```
myria-cluster list test-cluster --metadata --region us-west-2

{
    "ami_id": "ami-f5973b95",
    "cluster_log_level": "WARN",
    "cluster_size": 5,
    "coordinator_mem_gb": 5.4,
    "coordinator_vcores": 1,
    "data_volume_count": 1,
    "data_volume_iops": null,
    "data_volume_size_gb": 20,
    "data_volume_type": "gp2",
    "driver_mem_gb": 0.5,
    "heap_mem_fraction": 0.9,
    "instance_type": "t2.large",
    "node_mem_gb": 6.0,
    "node_vcores": 2,
    "role": null,
    "spot_price": null,
    "state": "running",
    "storage_type": "ebs",
    "subnet_id": null,
    "unprovisioned": false,
    "worker_mem_gb": 5.4,
    "worker_vcores": 1,
    "workers_per_node": 1,
    "zone": null
}
```

You can save considerable costs (up to 90%) for large clusters by using [EC2 spot instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances.html). You configure your maximum bid price with the `--spot-price` parameter to `myria-cluster create`. (Note that you only ever actually pay the current spot price, not your maximum bid price.) If the current spot price exceeds your maximum bid price, or if the instance type you specify is not available in the quantity you specify, your instances will be terminated. In general, it’s best to use [previous generation instance types](https://aws.amazon.com/ec2/previous-generation/) for spot instances (for cost and availability reasons), and to specify the `--zone` ([EC2 Availability Zone](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)) and `--spot-price` options to `myria-cluster create` based on [spot instance pricing history](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-spot-instances-history.html). Here’s an example:

```
myria-cluster create spot-test-cluster --region us-west-2 --zone us-west-2a --spot-price 0.08 --cluster-size 80 --instance-type m2.2xlarge
```

If you decide not to use spot instances, you can still save considerable cost by stopping your cluster when not in use and restarting it on demand. This avoids all compute costs, and only incurs the EBS storage cost of $0.10/GB/month. The `myria-cluster stop` and `myria-cluster start` commands leverage EC2’s ability to stop and start EBS-backed instances (essentially equivalent to a reboot but possibly on different hardware). (Note that if you choose the `--storage-type local` option, you will be unable to stop your cluster, since data on local storage devices is lost when you stop an EC2 instance.)

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

Your Myria cluster 'test-cluster' in the AWS 'us-west-2' region has been successfully stopped.
You can start this cluster again by running `myria-cluster start test-cluster --region us-west-2`.
```

```
myria-cluster start test-cluster --region us-west-2

Starting instances i-7e2cd2a5, i-7d2cd2a6, i-7c2cd2a7
Waiting for started instances to become available...
Waiting for Myria service to become available...

Your Myria cluster 'test-cluster' in the 'us-west-2' region has been successfully restarted.
The public hostnames of all nodes in this cluster have changed.
You can view the new values by running

myria-cluster list test-cluster --region us-west-2

New public hostname of coordinator:
ec2-54-201-192-111.us-west-2.compute.amazonaws.com
```

```
myria-cluster list test-cluster --region us-west-2

WORKER_ID HOST
--------- ----
0         ec2-54-201-192-111.us-west-2.compute.amazonaws.com
1         ec2-54-187-52-118.us-west-2.compute.amazonaws.com
2         ec2-54-213-90-178.us-west-2.compute.amazonaws.com
```

If you find you need more nodes in your cluster, you can increase (but not decrease!) your cluster's size by using the `myria-cluster resize` command:

```
myria-cluster resize test-cluster --increment 1 --region us-west-2
                                                                                         
Launching instances...
Tagging instances...
Waiting for all instances to become reachable...
Waiting for Myria service to become available...
1 new nodes successfully added to cluster 'test-cluster'.
```

It may be that you need to deploy changes made to the Myria software since you created your cluster, and you don't want to destroy that cluster and create a new one. You can use the `myria-cluster update` command to update the Myria software on a running cluster:

```
myria-cluster update test-cluster --region us-west-2

Updating Myria software on cluster...
Myria software successfully updated.
```

When you're finished using your cluster, terminate the cluster using the `myria-cluster destroy` command:

```
myria-cluster destroy test-cluster --region us-west-2

Are you sure you want to destroy the cluster 'test-cluster' in the 'us-west-2' region? [y/N]: y
Terminating instances i-7e2cd2a5, i-7d2cd2a6, i-7c2cd2a7
Deleting security group test-cluster (sg-5605f630).
Security group test-cluster (sg-5605f630) successfully deleted
```

### __(Advanced) Create a custom Myria image__
If you need to install your own software to use with Myria (e.g., scientific or machine learning libraries), you can create your own custom Myria AMI (Amazon Machine Image). The `myria-cluster create-image` command will install the Myria software on a base image that you supply (which would contain the additional software you need to use with Myria), and create a new AMI that you can use to launch a Myria cluster with the `myria-cluster create` command (using the `--ami-id` option). (If you are unfamiliar with how to create a base AMI containing your additional software, see the [AWS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html). Currently, your base AMI must be created from an EBS-backed Ubuntu 14.04-based AMI, which you can look up [here](http://uec-images.ubuntu.com/query/trusty/server/released.txt).) To run `myria-cluster create-image`, you need to specify the ID of your base AMI, the region in which you want to launch the EC2 instance which creates the AMI, and the regions you want to copy the new AMI to (AMIs cannot be shared across regions). Here's an example:

```
myria-cluster create-image myria-hvm-test --base-ami-id ami-9abea4fb --region us-west-2 --description "Myria test HVM AMI" --overwrite --copy-to-region us-east-1 --copy-to-region us-west-1

Deregistering existing AMI with name 'myria-hvm-test' (ID: ami-d490dfc3) in region 'us-east-1'...
Deregistering existing AMI with name 'myria-hvm-test' (ID: ami-77a0e917) in region 'us-west-1'...
Deregistering existing AMI with name 'myria-hvm-test' (ID: ami-20f85440) in region 'us-west-2'...
Creating security group 'myria-hvm-test' in region 'us-west-2'...
Launching instances...
Tagging instances...
Waiting for all instances to become reachable...
Provisioning AMI builder instance...
Bundling image...
Waiting for AMI ami-1f278e7f in region 'us-west-2' to become available...
Copying image to other regions...
Waiting for AMI ami-39a19a2e in region 'us-east-1' to become available...
Waiting for AMI ami-42461122 in region 'us-west-1' to become available...
Tagging images...
Shutting down AMI builder instance...
Terminating instances i-130f6487
Deleting security group 'myria-hvm-test' (sg-5fecd526)
Security group 'myria-hvm-test' (sg-5fecd526) successfully deleted
Successfully created images in regions us-west-2, us-east-1, us-west-1:
REGION               AMI_ID
------               ------
us-west-2            ami-1f278e7f
us-east-1            ami-39a19a2e
us-west-1            ami-42461122
```

You can view all your images in specified regions using the `myria-cluster list-images` command:

```
myria-cluster list-images --region us-west-2 --region us-east-1 --region us-west-1

REGION               AMI_ID               VIRTUALIZATION_TYPE  NAME                           DESCRIPTION
------               ------               -------------------  ----                           -----------
us-west-2            ami-1f278e7f         hvm                  myria-hvm-test                 Myria test HVM AMI
us-east-1            ami-39a19a2e         hvm                  myria-hvm-test                 Myria test HVM AMI
us-west-1            ami-42461122         hvm                  myria-hvm-test                 Myria test HVM AMI
```

And finally, you can delete an image in specified regions using the `myria-cluster delete-image` command:

```
myria-cluster delete-image myria-hvm-test --region us-west-2 --region us-east-1 --region us-west-1

Are you sure you want to delete the AMI 'myria-hvm-test' in the us-west-2, us-east-1, us-west-1 regions? [y/N]: y
Deregistering AMI with name 'myria-hvm-test' (ID: ami-1f278e7f) in region 'us-west-2'...
Deregistering AMI with name 'myria-hvm-test' (ID: ami-39a19a2e) in region 'us-east-1'...
Deregistering AMI with name 'myria-hvm-test' (ID: ami-42461122) in region 'us-west-1'...
```
