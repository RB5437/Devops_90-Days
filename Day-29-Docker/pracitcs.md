ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ chmod 744 create_ec2.sh
chmod: changing permissions of 'create_ec2.sh': Operation not permitted
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo chmod 744 create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./create_ec2.sh
-bash: ./create_ec2.sh: Permission denied
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
AWS CLI is not installed. Please install it first.
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
AWS CLI is not installed. Please install it first.
Creating EC2 instance...
./create_ec2.sh: line 59: aws: command not found
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
AWS CLI is not installed. Please install it first.
./create_ec2.sh: line 75: cd: install_awscli: No such file or directory
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
AWS CLI is not installed. Please install it first.
Installing AWS CLI v2 on Linux...
You can now run: /usr/local/bin/aws --version
aws-cli/2.34.35 Python/3.14.4 Linux/6.17.0-1007-aws exe/x86_64.ubuntu.24
Creating EC2 instance...

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ aws configure

Tip: You can deliver temporary credentials to the AWS CLI using your AWS Console session by running the command 'aws login'.


aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ aws login

aws: [ERROR]: An error occurred (Configuration): Profile 'default' is already configured with Access Key credentials.

You may run 'aws login --profile new-profile-name' to create a new profile with the specified name. Otherwise you must first manually remove the existing credentials from 'default'.
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
Creating EC2 instance...

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
Creating EC2 instance...

aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./create_ec2.sh
-bash: ./create_ec2.sh: Permission denied
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo mkdir -p /root/.aws
sudo cp -r ~/.aws/* /root/.aws/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ aws configure
AWS Access Key ID [****************HOUZ]: AKIA5FD4YRBI35PHHOUZ
AWS Secret Access Key [****************ANVU]: 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
Default region name [ap-south-1]:
Default output format [None]:
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ aws sts get-caller-identity
{
    "UserId": "AIDA5FD4YRBI2ZS4RHWE6",
    "Account": "904352270417",
    "Arn": "arn:aws:iam::904352270417:user/shell-admin"
}
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./create_ec2.sh
-bash: ./create_ec2.sh: Permission denied
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
Creating EC2 instance...

aws: [ERROR]: An error occurred (InvalidKeyPair.NotFound) when calling the RunInstances operation: The key pair '
aws.pem' does not exist
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo vi create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./create_ec2.sh
Creating EC2 instance...
Instance i-059f22c3b806ed6c6 created successfully.
Waiting for instance i-059f22c3b806ed6c6 to be in running state...
Instance i-059f22c3b806ed6c6 is now running.
EC2 instance creation completed.
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$
ubuntu@ip-172-31-47-139:~$ ls
Devops_90-Days
ubuntu@ip-172-31-47-139:~$ cd Devops_90-Days/
ubuntu@ip-172-31-47-139:~/Devops_90-Days$ ls
Day-01-Linux  Day-03-Linux  Day-05-Linux       Day-07-Networking       Day-09-Shell_Scripting  Day-11-Shell_Scripting
Day-02-Linux  Day-04-Linux  Day-06-Networking  Day-08-Shell_Scripting  Day-10-Shell_Scripting  README.md
ubuntu@ip-172-31-47-139:~/Devops_90-Days$ cd Day-11-Shell_Scripting/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ LS
LS: command not found
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo chmod 744 backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo ./backup.sh
Useage:
./backup.sh <path to your source> <path to backup folder>
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ mkdir  backup
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ pwd
/home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
backup  backup.sh  create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./ backup
backup/    backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./ backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
-bash: ./: Is a directory
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/
Devops_90-Days/Day-11-Shell_Scripting/backup
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ date
Thu Apr 23 10:46:01 UTC 2026
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ date '+%Y-%m-%d-%H-%M-%S'
2026-04-23-10-47-27
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 25: zip: command not found
backup generated successfully for 2026-04-23-10-52-02
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 25: zip: command not found
backup generated successfully for 2026-04-23-10-53-26
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 31: syntax error near unexpected token `}'
./backup.sh: line 31: `}'
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh

ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 25: zip: command not found
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ sudo apt-get update
sudo apt-get install zip -y
Hit:1 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Get:2 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Hit:3 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease
Get:4 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates/main amd64 Packages [1918 kB]
Get:5 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates/universe amd64 Packages [1685 kB]
Get:6 http://security.ubuntu.com/ubuntu noble-security InRelease [126 kB]
Get:7 http://security.ubuntu.com/ubuntu noble-security/main amd64 Packages [1620 kB]
Get:8 http://security.ubuntu.com/ubuntu noble-security/main amd64 c-n-f Metadata [11.0 kB]
Fetched 5487 kB in 3s (1807 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  zip
0 upgraded, 1 newly installed, 0 to remove and 66 not upgraded.
Need to get 176 kB of archives.
After this operation, 549 kB of additional disk space will be used.
Get:1 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates/main amd64 zip amd64 3.0-13ubuntu0.2 [176 kB]
Fetched 176 kB in 0s (9243 kB/s)
Selecting previously unselected package zip.
(Reading database ... 72584 files and directories currently installed.)
Preparing to unpack .../zip_3.0-13ubuntu0.2_amd64.deb ...
Unpacking zip (3.0-13ubuntu0.2) ...
Setting up zip (3.0-13ubuntu0.2) ...
Processing triggers for man-db (2.12.0-4build2) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
  adding: home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh (deflated 57%)
backup generated successfully for 2026-04-23-10-58-54
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
backup  backup.sh  create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ cd backup/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ ls
backup_2026-04-23-10-58-54.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ cd ..
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-01-02
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ cd backup/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ ls
backup_2026-04-23-10-58-54.zip  backup_2026-04-23-11-01-02.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ cd ..
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-01-44
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-01-45
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-01-46
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ cd backup/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ ls
backup_2026-04-23-10-58-54.zip  backup_2026-04-23-11-01-44.zip  backup_2026-04-23-11-01-46.zip
backup_2026-04-23-11-01-02.zip  backup_2026-04-23-11-01-45.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ cd ..
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
backup  backup.sh  create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-04-47
./backup.sh: line 33: ls -t /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_*.zip: division by 0 (error token is "home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_*.zip")
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-06-20
/home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-06-20.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-04-47.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-46.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-45.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-44.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-02.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-10-58-54.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-09-09
./backup.sh: line 36: [: missing `]'
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-10-06
performing rotation for 5 days
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 40: unexpected EOF while looking for matching `"'
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh

ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
./backup.sh: line 40: unexpected EOF while looking for matching `"'
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh

ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-18-16
performing rotation for 5 days
/home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-46.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-45.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-44.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-02.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-10-58-54.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-21-01
performing rotation for 5 days
/home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-04-47.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-46.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-45.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-44.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-11-01-02.zip /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup/backup_2026-04-23-10-58-54.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ cd backup/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ ls
backup_2026-04-23-11-06-20.zip  backup_2026-04-23-11-10-06.zip  backup_2026-04-23-11-21-01.zip
backup_2026-04-23-11-09-09.zip  backup_2026-04-23-11-18-16.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ vi backup.sh cd ..
3 files to edit
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ cd ..
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ls
backup  backup.sh  create_ec2.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ vi backup.sh
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ ./backup.sh  /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/create_ec2.sh /home/ubuntu/Devops_90-Days/Day-11-Shell_Scripting/backup
backup generated successfully for 2026-04-23-11-22-57
performing rotation for 5 days
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting$ cd backup/
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$ ls
backup_2026-04-23-11-09-09.zip  backup_2026-04-23-11-18-16.zip  backup_2026-04-23-11-22-57.zip
backup_2026-04-23-11-10-06.zip  backup_2026-04-23-11-21-01.zip
ubuntu@ip-172-31-47-139:~/Devops_90-Days/Day-11-Shell_Scripting/backup$
