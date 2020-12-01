# rstudio-docker

heavily inspired by https://github.com/PawseySC/rstudio-nginx

# Setup

## GWDG Cloud server

Create a server with the most recent Ubuntu and make sure that the ports 80, 443 and 22 are open. SSH into your server, change the password and update all packages:

```
sudo apt update && sudo apt -y dist-upgrade # might be blocked due to auto update... just be patient
```

## Install docker:
 
```
sudo apt -y install curl gnupg2 apt-transport-https ca-certificates  software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update
sudo apt -y install docker-ce
```
 
## Install docker-compose

Have a look at https://github.com/docker/compose/releases and see which is the most recent release. At the time of this writing, it is version  `1.27.4`

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod a+x /usr/local/bin/docker-compose

docker-compose --version  # just checkin'
```

# Clone this repository

```
git clone https://github.com/bitbacchus/rstudio-docker.git
cd rstudio-docker
```

# Create a custom Docker image (optional)
Either use my image (default, just skip this paragraph) or create your own local version of it. Adjust the Dockerfile to your needs and run the following command to build the image from that Dockerfile (this will take a while).
```
sudo docker build -t sebastianhanss/rstudio:latest .
```
If you use a different tag than `sebastianhanss/rstudio:latest` remember to adjust your `docker-compose.yml` accordingly.

# Quick Start

* Edit `docker-compose.yml`
	* Change `VIRTUAL_HOST` and `LETSENCRYPT_HOST` to your domain name (e.g. `c10x-xxx.cloud.gwdg.de`)
	* Change `USER` and  `PASSWORD` to your desired RStudio username and password
	* Change `LETSENCRYPT_EMAIL` to your preferred email address (it will be associated with the generated certificates)
	* If you want to mount any directories into your RStudio container you need to change the `VOLUMES TO BE MOUNTED` line in the `rstudio` section.  An example is given in the `docker-compose.yml` file, where the directory `rstudio_home` is mounted to `/home` in the container
* Run `sudo docker-compose up -d` to start the containers

You should now have a working RStudio server that you can access via a web browser at *`c10x-xxx.cloud.gwdg.de`*.

More explanations at https://github.com/PawseySC/rstudio-nginx
