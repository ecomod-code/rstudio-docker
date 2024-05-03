FROM rocker/geospatial:4.4.0

RUN apt-get update && apt-get install -y software-properties-common && apt-get dist-upgrade -y 
RUN apt-get install -y --no-install-recommends \ 
     jags \
     gsl-bin libgsl-dev \
     htop \
     gnupg2 \
     libzmq3-dev \
     libgmp3-dev \
     libssh-dev \
     openssh-client \  
     python3-dev \
     python3-pip \   
     libmagick++-dev
RUN install2.r --error \
     bench \
     betapart \
     rjags \
     clustermq \
     devtools \
     furrr \
     future \
     future.apply \
     future.batchtools \
     landscapemetrics \
     landscapetools\
     magick \
     microbenchmark \
     # NLMR \
     nlrx \
     plotrix \
     rasterVis \
     rcdd \
     Rcpp \
     remotes \
     RInside \
     rslurm \
     skimr \
     ssh \
     ssh \
     targets \
     tidyverse \
     usethis \
     vegan \
     withr 

   
RUN Rscript -e "devtools::install_github(\"EFForTS-B10/Refforts\", upgrade = \"always\")" 
# terra needs a rebuild with a new GDAL
RUN Rscript -e "devtools::install_github(\"rspatial/terra\", upgrade = \"always\")"
RUN Rscript -e "devtools::install_github(\"cran/RandomFields\", upgrade = \"always\")"
# RUN Rscript -e "devtools::install_github(\"ropensci/NLMR\", upgrade = \"always\")" 

RUN pip3 install --upgrade pip

# Install InVEST
# RUN pip install natcap.invest==3.11.0

RUN export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf

