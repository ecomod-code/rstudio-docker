FROM rocker/geospatial:latest
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
     htop \
     libzmq3-dev \
     libgmp3-dev \
     openssh-client \     
     libmagick++-dev
RUN install2.r --error \
     RInside \
     Rcpp \
     landscapemetrics \
     landscapetools\
  #   NLMR \
     bench \
     nlrx \
     furrr \
     future \
     future.apply \
     future.batchtools \
     devtools \
     rasterVis \
     skimr \
     plotrix \
     betapart \
     rcdd \
     slackr \
     targets \
     magick \
     withr
RUN Rscript -e "devtools::install_github(\"mschubert/clustermq\", upgrade = \"always\")"     
RUN echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf
RUN sudo rstudio-server restart
