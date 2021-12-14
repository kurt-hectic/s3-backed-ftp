# S3-Backed-FTP Server

An ftp/sftp server using s3fs to mount an external s3 bucket as ftp/sftp storage.

More info [here](http://cloudacademy.com/blog/s3-ftp-server/).

## Usage

To run:

1. Replace `env.list.example` file with a real `env.list` file with correct variables filled in.
    - Add users to `USERS` environment variable. These should be listed in the form `username:hashedpassword`, each separated by a space.
     - Passwords for those users should be hashed. There are several ways to hash a user password. A common way is to execute a command like the following: `openssl passwd -crypt {your_password}`. Substitute `{your_password}` with the one you want to hash.
     - You may also use non-hashed passwords if storing passwords in plaintext is fine. To do this, change line ` echo $u | chpasswd -e ` => ` echo $u | chpasswd ` in the `users.sh` file (line #24).
    - Specify the S3 buckets were the files (`FTP_BUCKET`) and configs (`CONFIG_BUCKET`) will be stored.
    - If you are running this container inside an AWS EC2 Instance with an assigned IAM_ROLE, then specify its name in the `IAM_ROLE` environment variable.
    - If you do not have an IAM_ROLE attached to your EC2 Instance or wherever you are running this, then you have to specify the AWS credentials that will be used to access S3. These are the `AWS_ACCESS_KEY_ID` and the `AWS_SECRET_KEY_ID` keys.

2. If you have changed other files aside the `env.list` file, then you have to build the docker container using:

    - `docker build --rm -t <docker/tag> path/to/dockerfile/folder`

    - `docker run --rm -p 21-22:21_22 -p 60000-60100:60000-60100  --name <name> --cap-add SYS_ADMIN --device /dev/fuse  -v %cd%/vsftpd.key:/etc/ssl/private/vsftpd.key -v %cd%/vsftpd.crt:/etc/ssl/certs/vsftpd.crt  -v %cd%/ssh_host_rsa_key:/etc/ssh/ssh_host_rsa_key -v %cd%/ssh_host_dsa_key:/etc/ssh/ssh_host_dsa_key --env-file env.list <docker/tag>`
	
    
## Environment Variables

1. ` USERS ` = List of users to add to the ftp/sftp server. Listed in the form username:hashedpassword, each separated by a space.
2. ` FTP_BUCKET ` = S3 bucket where ftp/sftp users data will be stored.
3. ` CONFIG_BUCKET ` = S3 bucket where the config data (env.list file) will be stored.
4. ` IAM_ROLE ` = name of role account linked to EC2 instance the container is running in.

### Optional Environment Variables
These two environment variables only need to be set if there is no linked IAM role to the EC2 instance.

1. ` AWS_ACCESS_KEY_ID ` = IAM user account access key.
2. ` AWS_SECRET_ACCESS_KEY ` = IAM user account secret access key.

**Enjoy!**
"# s3-backed-ftp" 
