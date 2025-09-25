FROM rocker/geospatial:latest

# Add Ubuntugis repo for GDAL 3.3.2 
RUN apt-get update && apt-get install -y software-properties-common && \
      apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable

RUN apt-get update && apt-get dist-upgrade -y 
RUN apt-get install -y --no-install-recommends \ 
     htop \
     gnupg2 \
     libzmq3-dev \
     libgmp3-dev \
     libssh-dev \
     openssh-client \  
     python3-dev \
     python3-pip \   
     libmagick++-dev \
     gdal-bin \
     libgdal-dev
RUN install2.r --error \
     bench \
     betapart \
     clustermq \
     devtools \
     furrr \
     future \
     future.apply \
     future.batchtools \
     landscapemetrics \
   #  landscapetools\
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
     targets \
     tidyverse \
     usethis \
     vegan \
     withr 

   
RUN Rscript -e "devtools::install_github(\"EFForTS-B10/Refforts\", upgrade = \"always\")" 
RUN Rscript -e "devtools::install_github(\"ropensci/NLMR\", upgrade = \"always\")" 

RUN pip3 install --upgrade pip

# Install InVEST
RUN pip3 install numpy==1.20.0 #(numpy must be installed before GDAL)
RUN pip3 install GDAL==3.3.2 #(has to match the version of pygdal)

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

RUN pip3 install chardet==4.0.0 Cython==0.29.24 GDAL==3.3.2 natcap.invest==3.9.0 numpy==1.20.0 pandas==1.3.0 psutil==5.8.0 pygdal==3.3.2.10 pygeoprocessing==2.1.2 Pyro4==4.77 python-dateutil==2.8.2 pytz==2021.1 retrying==1.3.3 Rtree==0.9.7 scipy==1.4.1 serpent==1.40 Shapely==1.7.1 six==1.16.0 taskgraph==0.10.3 xlrd==2.0.1 xlwt==1.3.0

RUN export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
RUN echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf


