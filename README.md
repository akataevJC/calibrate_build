# Set up
## Docker
First things first, you should install the Docker itself.
Just download it from here https://www.docker.com/products/docker-desktop and follow instructions.
You should be able to run ```docker --version``` and get currently installed version.

## Git
Run ```git --version```, if you didn't get something like ```git version ...```, then go here 
https://git-scm.com/ fetch it up and install.

## GitHub
* Create an SSH Token: https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
* Add this token to your Github: https://github.com/settings/keys

## AWS account
Before your start ensure you have AWS credentials ready and set. For now, the only credentials you need are
**account_id**, **access_key_id**, **secret_access_key**. You may consult your mananager, how to get them.

### Create credentials file
```bash
cd && mkdir .aws && cd .aws
nano credentials
```
this should create an empty file `~/.aws/credentials` and open it in **Nano** editor.
You may use any other text-editor to edit the file. Copy and paste this template 
to the editor and fill in credentials
```
[account_id]
aws_access_key_id = [your access_key_id]
aws_secret_access_key = [your secret_access_key]
```
Result file contents should look like this e.g 
```bash
[goodco]
aws_access_key_id = mysecretid
aws_secret_access_key = myveryverysecretid
```
# Build
## Repository
```bash
cd && git clone git@github.com:Calibrate-Health/calibrate.git && cd calibrate
```

## Create secure.env file
```bash
cp project/config/dev.secure.env build/secure.env && cd build
```

## Create Docker image
```bash
docker build --build-arg AWS_PROFILE=[your_aws_profile_name] --secret id=aws,src=$HOME/.aws/credentials . -t calibrate:dev
```

Looks good so far. Now, some house keeping. 

## Migrate and Collect Static
```bash
# Prepare static files
docker-compose run --rm calibrate django collectstatic --no-input  
```
```bash
# Prepare database
docker-compose run --rm calibrate django migrate --no-input
```
```bash
# Create admin user
docker-compose run --rm calibrate django createsuperuser --username admin --email admin@calibrate.com
```
You will be asked to provide some password, don't ponder to much, it will be used by only you, so stick with 
some simple fraze.

So, we are ready to go.

# Run
To get some handy commands at your disposal, run
```bash
docker-compose run --rm calibrate help 
```
Give a try for a useful django shell. Its power is in quick hypotheses testing, commands execution and much more.
```bash
docker-compose run --rm calibrate django shell 
```

## Test
Before you start writing code run some tests. 
You may find available options for `pytest` here https://docs.pytest.org/en/6.2.x/reference.html#command-line-flags
```bash
docker-compose run --rm calibrate pytest
```

## Server
Before running up server you would want to copy *gunicorn* settings to you project directory
```bash
cp gunicorn.conf.py calibrate
```

```bash
docker-compose run --service-ports --rm calibrate server  
```
Go to http://0.0.0.0:8000/admin/ and put down admin credentials you entered on the previious steps.
Username: admin, Password: [yourpassword]

Congrats! You made it! 
