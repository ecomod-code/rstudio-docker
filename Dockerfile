FROM ecomod/rstudio:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  python3-pip \
  gnupg \ # needed to add the ubuntu repositories

RUN echo 'deb http://ppa.launchpad.net/ubuntugis/ppa/ubuntu focal main ' >> /etc/apt/sources.list.d/ubuntugis-stable.list \
  && echo 'deb-src http://ppa.launchpad.net/ubuntugis/ppa/ubuntu focal main ' >> /etc/apt/sources.list.d/ubuntugis-stable.list \
  && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160RUN apt-get update \
  && apt upgrade -y

RUN apt-get install -y --no-install-recommends \
  gdal-bin \
  libgdal-dev

RUN Rscript -e "devtools::install_github(\"nldoc/Refforts\", upgrade = \"always\")"

#we will use pip to install the python packages
RUN pip3 install --upgrade pip
RUN pip3 install numpy==1.20.0 #(numpy must be installed before GDAL)
RUN pip3 install GDAL==3.2.1 #(has to match the version of pygdal)

RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal

RUN pip3 install chardet==4.0.0 Cython==0.29.24 GDAL==3.2.1 natcap.invest==3.9.0 numpy==1.20.0 pandas==1.3.0 psutil==5.8.0 pygdal==3.2.1.7 pygeoprocessing==2.1.2 Pyro4==4.77 python-dateutil==2.8.2 pytz==2021.1 retrying==1.3.3 Rtree==0.9.7 scipy==1.4.1 serpent==1.40 Shapely==1.7.1 six==1.16.0 taskgraph==0.10.3 xlrd==2.0.1 xlwt==1.3.0

WORKDIR .

