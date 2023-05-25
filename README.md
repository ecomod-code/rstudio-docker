# rstudio-docker

heavily inspired by https://github.com/PawseySC/rstudio-nginx

Our docker hub repo: https://hub.docker.com/r/ecomod/rstudio/tags

# Setup

## [GWDG Cloud server](https://info.gwdg.de/dokuwiki/doku.php?id=en:services:server_services:gwdg_cloud_server:manual_v3)

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

### Configure MTU

If Docker runs on a virtual machine and your container encounters network issues you might need to configure Docker's [MTU](https://en.wikipedia.org/wiki/Maximum_transmission_unit). On a GWDG Cloud server you need to create `/etc/docker/daemon.json`:

```
sudo nano /etc/docker/daemon.json
```
with the contents
```
{
  "mtu": 1450
}
```
Then, `systemctl restart docker` and rebuild your container(s) if you had some, already.


Note: if you configure custom network bridges and use `docker-compose`, you'll need to configure MTU [in your docker-compose file](https://mlohr.com/docker-mtu/) 


## Install docker-compose

Have a look at https://github.com/docker/compose/releases and see which is the most recent release. At the time of this writing, it is version  `v2.5.0`

```
sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod a+x /usr/local/bin/docker-compose

docker-compose --version  # just checkin'
```

# Clone this repository

```
git clone https://github.com/ecomod-code/rstudio-docker.git
cd rstudio-docker
```

# Create a custom Docker image (optional)

Either use my image (default, just skip this paragraph) or create your own local version of it. Adjust the Dockerfile to your needs and run the following command to build the image from that Dockerfile (this will take a while). You'll need to have your mtu set properly (see above).
```
sudo docker build -t ecomod/rstudio:latest .
```
If you use a different tag than `ecomod/rstudio:latest` remember to adjust your `docker-compose.yml` accordingly.

# Quick Start

* create a `.env` file from the template `cp .env.template .env`
* Edit the environment file, e.g. `nano .env`
	* `Server_URL` is the domain name of your server (e.g. `c10x-xxx.cloud.gwdg.de`)
	* `RStudio_Username` and  `RStudio_Password` will be the  user name and password for your RStudio Server. Choose a strong password as your server is available from the Internet
	* your `e_mail_address` will be associated with the generated certificates for the encrypted connection to your server. It does not generate Spam you will just be notified when your certificate is about to expire
	* `ROOT=false` means that your RStudio user will have no admin rights in the container. This improves security, but you can change it to `yes` if you need admin rights
* Save your changes `Ctrl+O` and exit the editor `Strl+X`
* Run `sudo docker-compose up -d` to start the containers

You should now have a working RStudio server that you can access via a web browser at *`c10x-xxx.cloud.gwdg.de`*.

More explanations at https://github.com/PawseySC/rstudio-nginx
