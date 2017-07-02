Cloud9 v3 in docker on Raspberry Pi
=============

This is a fork from [BarryWilliams](https://github.com/BarryWilliams/cloud9-docker-arm) which was forked from [kdelfour](https://github.com/kdelfour/cloud9-docker) and used [flyingprogrammer's repo](https://github.com/flyinprogrammer/cloud9-with-carina) for reference. Excellent work.

The reason for the fork is getting the contianer to build given the base image has been deprecated, it is now using an armhf ubuntu version 16.10 image.

The major differences in this fork are the following:
  1. It switches the docker user to a restricted user using an current method, and allows you to optionally set the sudo password for that user with a build argument
  2. Node runs as a non-root user - and now allows you to define the port instead of locking to 8080
  3. You now get go 1.8 and Node8 installed and available to the cloud9 ide (in addition to python2.7)
  4. Cloud9 authentication is now default and set, with the option to set your own authentication (recommended)

# Base Docker Image
[armv7/armhf-ubuntu:16.10](https://hub.docker.com/r/armv7/armhf-ubuntu/)

# Docker Hub Image
[chrisdlangton/cloud9-docker-arm](https://hub.docker.com/r/chrisdlangton/cloud9-docker-arm/)

# Installation

## Install Docker
Run `curl -sSL get.docker.com | sh` to install followed by `sudo systemctl enable docker` to enable, and `sudo usermod -aG docker pi` to allow the `pi` user to run `docker` commands without `sudo`

## Run it

```
docker run -it -d -p 80:8080 chrisdlangton/cloud9-docker-arm
```    
You can also provide auth credentials
```    
docker run -d -p 80:8080 -e AUTH=user:pass chrisdlangton/cloud9-docker-arm
``` 
You can add a workspace as a volume directory with the argument `-v /your-path/workspace/:/workspace/` like this :
```
docker run -it -d -p 80:8080 -v /your-path/workspace/:/workspace/ chrisdlangton/cloud9-docker-arm
``` 
## Use it

Navigate to your raspberry pi: `http://<your pi's address>`

## Build it yourself

Clone the latest repo on a Raspberry Pi with Docker.
```
git clone https://github.com/chrisdlangton/cloud9-docker-arm
```

Build it
```
docker build cloud9-docker-arm/ --force-rm=true --tag="$DOCKER_HUB_USER/cloud9-docker-arm:latest" .
```   
And run
```
docker run -d -p 80:80 -v /your-path/workspace/:/workspace/ $USER/cloud9-docker-arm:latest
``` 
Enjoy !!    
