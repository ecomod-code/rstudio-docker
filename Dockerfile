FROM rocker/geospatial:4.0.0-ubuntu18.04
RUN apt-get update \
  && apt-get install -y --no-install-recommends \ 
     htop \
     libzmq3-dev \
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
     plotrix \
     magick \
     withr
RUN Rscript -e "devtools::install_github(\"mschubert/clustermq\", upgrade = \"always\")"     

RUN wget https://www.imagemagick.org/download/ImageMagick.tar.gz \
&& tar xvzf ImageMagick.tar.gz \
&& cd ImageMagick-7.0.10-11 \
&& ./configure \
&& make \
&& make install \
&& ldconfig /usr/local/lib

   
ENV USER rstudio
ENV ROOT=TRUE
