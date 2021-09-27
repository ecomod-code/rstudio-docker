FROM rocker/geospatial:latest
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
     htop \
     gnupg2 \
     libzmq3-dev \
     libgmp3-dev \
     libssh-dev \
     openssh-client \     
     libmagick++-dev
RUN install2.r --error \
     RInside \
     Rcpp \
     landscapemetrics \
     landscapetools\
     NLMR \
     bench \
     nlrx \
     furrr \
     future \
     future.apply \
     future.batchtools \
     devtools \
     rasterVis \
     skimr \
     ssh \
     plotrix \
     vegan \
     betapart \
     rcdd \
     remotes \
     slackr \
     targets \
     magick \
     clustermq \
     ssh \
     withr
RUN echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf
RUN sudo rstudio-server restart

RUN export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
