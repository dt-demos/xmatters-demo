# Welcome 

These are the steps to setup the sample application on the VM.  There are two docker-compose files to run a 'production' and a 'staging' instances of the application.  

# Prereqs

1. 'production' runs on port 80 and 'staging' runs on port 81, so ensure the VM had has a public IP and these ports open.

1. On the VM to run the application run the following

    ```
    # general utilities
    sudo yum update -y
    sudo yum install git -y
    sudo yum install jq -y

    # docker
    # Reference:* https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html

    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo docker info

    # docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
    docker-compose version
    ```

1. Install the Dynatrace OneAgent on the VM

1. clone this repo `git clone https://github.com/dt-demos/xmatters-demo.git`

# Start the application 

1. From the cloned repo, navigate to the app subfolder

2. Adjust YAML filename (staging or production) for the this command that will start the app 

    ```
    cd xmatters-demo/app
    docker-compose -f docker-compose-staging.yaml up -d
    ```


# Check that frontend and service containers are running

It takes about 45 seconds to start, but then the application can be accessed

Verify pods with `docker-compose ps`

Open the front-end in a browser for the app  `http://PUBLIC-IP` 

# Stop the application

Run this command to stop 

```
docker-compose -f docker-compose-staging.yaml down
```

# Simulated traffic

Once the application is running, clone these repos for scripts that will create traffic against the running application
* [Browser traffic](https://github.com/dt-orders/browser-traffic)
* [Load traffic](https://github.com/dt-orders/load-traffic)