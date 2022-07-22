# terraform_demo

This repo contains useful scripts for developing solutions on AWS with Terraform.

## Developing

To start developing, open a terminal (it is strongly recommended that you use a terminal inside VS Code, but it's your choice).

### 1. Start AWS CLI

Start docker with AWS CLI image augmented with additional packages (terraform, kubectl, helm, eksctl, python etc):
```
./terraform_run.ps1
```

Note: If your Windows host does not allow you to execute terraform_run.ps1 script, open PowerShell as administrator and run the following command
```
set-executionpolicy remotesigned
```

You are now inside the docker container and the whole folder is mounted as your working directory. Your docker has access to all of the files inside this folder and you can still edit them with visual code on your host machine (or another text editor of your choice).

### 2. Connect to AWS

Edit the file **mfa.sh** and change lines: 5, 9, 10 (follow the comments). It is a one time action.

Connect to AWS with the following command (change 123456 to your MFA Code from your mobile app)
```
source ./mfa.sh 123456
```
or
```
. ./mfa.sh 123456
```
and remember that if you type it without the first dot or "source" keyword, like this
```
./mfa.sh 123456
```
it will not work. You must "source" the file.

You can verify the connection with command
```
aws s3 ls
```
If it displays S3 buckets, everything is working.

### 3. Connect to Azure
Login to MS Azure with Azure CLI command

```
az login
```

to complete login follow the instructions from terminal.

You can verify the connection with command
```
az account show
```
If it displays your account, everything is working.

### 4. Terraform setup
Change directory to "/work/aws_jupyter" if you work on aws or "/work/azure_jupyter" if you work with Azure.
Terraform command init, plan, apply will work the same way no matter which cloud provider you are using.

To initialize terraform project run: 

```
terraform init
```

Note: If you don't know your IP, please use [amazon site](https://checkip.amazonaws.com/).

after initialization run "terraform plan" command to see execution plan of deployment:

```
terraform plan -var='allowed_ips=["<<Put-your-ip-here>>/32"]'
```

to apply deployment run. 


```
terraform apply -var='allowed_ips=["<<Put-your-ip-here>>/32"]'
```

When you will prompt, type "yes". After creation of environment check console output for IP which were assigned to EC2 instance.
Open yout browser and put there IP address from console output. Now you should be able to see jupyter lab page. Authorization token is set to admin by default.

When you finished remember to remove resources you have created. To do it run "terraform destroy" command.

```
terraform destroy -var='allowed_ips=["<<Put-your-ip-here>>/32"]'
```