# polymath_devops_take-home-exercise
Polymath Network - Senior Devops Take Home Assignment

I did reuse a lot of code from others as a time saver and would recreate the modules to my needs if this was for a PROD env.
I'm assuming that you'll have the following installed:
 * aws cli
 * packer
 * terraform
 * nomad

So to use this as is, you'll need to setup your AWS credentials (I did set it as DEFAULT) to an Identity with full Admin rights.
In the configurations you'll have to set the region to "eu-west-1" for it to work with some of the hardcoded configs.

Then you should create the AMI's using packer (at least once):
```sh
packer build images/packer-nomad-consul-ami/nomad-consul-docker.json
```

Copy the AMI of choice and add it to the terraform file at `./infrastructure/provision-nomad-cluster-aws/main.tf` (I've done my tests with `amazon-linux-2-amd64-ami`)

Then to provision the cluster:
```sh
cd infrastructure/provision-nomad-cluster-aws
terraform apply
cd - # Go back to base directory
```

After this we'll need to know the IP of one of the Server Instances.
I haven't implemented anything to get this and currently get this value from the AWS Console.

We no can run some nomad commands, let's check our cluster members:
```sh
nomad server members -address="http://{SERVER_IP}:4646"
```

provision the nomad job:
```sh
nomad run -address="http://{SERVER_IP}:4646" ./jobs/polymath-simplewebapp.nomad
```

Note: It's still a bit buggy. I need to improve the server configurations and figure out how to expose an app port.