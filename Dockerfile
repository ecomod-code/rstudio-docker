FROM rocker/geospatial:4.5

# ----- system deps -----
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      software-properties-common \
      jags \
      gsl-bin libgsl-dev \
      htop \
      gnupg2 \
      libzmq3-dev \
      libgmp-dev \
      libssh-dev \
      openjdk-21-jre \
      openssh-client \
      python3-dev \
      python3-pip \
      libmagick++-dev libmagickwand-dev libmagickcore-dev \
      curl git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# ----- R packages -----
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
     magick \
     microbenchmark \
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

# ----- GitHub installs -----  
RUN Rscript -e 'remotes::install_github("EFForTS-B10/Refforts@dev2.0", upgrade = "never")' && \
    Rscript -e 'remotes::install_github("ropensci/NLMR", upgrade = "never")' && \
    Rscript -e 'remotes::install_github("ropensci/landscapetools", upgrade = "never")'

# ----- Persist JAVA_HOME and add to PATH -----
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# ---------- InVEST 3.11.0 via micromamba (Python 3.9) ----------
ARG MAMBA_ROOT=/opt/conda
ENV MAMBA_ROOT_PREFIX=${MAMBA_ROOT}
ENV PATH=${MAMBA_ROOT}/envs/invest/bin:$PATH

# 1) micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
      | tar -xvj -C /usr/local/bin/ bin/micromamba --strip-components=1

# 2) env with compatible pins
RUN micromamba create -y \
      -r ${MAMBA_ROOT} \
      -n invest \
      -c conda-forge \
      python=3.9 \
      natcap.invest==3.11.0 \
      "numpy>=1.20,<1.24" \
      "gdal>=3.2,<3.6" \
      pip && \
    micromamba clean -a -y

# 3) headless proof
RUN python -c "import natcap.invest as i; print(i.__version__)" && \
    python -V && \
    gdalinfo --version
# ---------- end InVEST ----------

# ---------- NetLogo multi-version (6.2.1, 6.4.0, 7.0.0) + NetVest ----------
ARG NETLOGO_ROOT=/opt/netlogo
ARG NETLOGO_NetVEST=6.2.1
ARG NETLOGO_6=6.4.0
ARG NETLOGO_7=7.0.0

# Choose 6.2.1 as the default for NetVEST
ENV NETLOGO_ROOT=${NETLOGO_ROOT} \
    NETLOGO_DEFAULT=${NETLOGO_NetVEST} \
    NETVEST_HOME=/opt/NetVest \
    JAVA_TOOL_OPTIONS="-Djava.awt.headless=true"

# Fetch & install the three NetLogo versions
RUN set -eux; \
    mkdir -p "${NETLOGO_ROOT}"; \
    for v in ${NETLOGO_NetVEST} ${NETLOGO_6} ${NETLOGO_7}; do \
      url="https://ccl.northwestern.edu/netlogo/${v}/NetLogo-${v}-64.tgz"; \
      tmp="/tmp/netlogo-${v}.tgz"; \
      dest="${NETLOGO_ROOT}/${v}"; \
      echo "Downloading $url"; \
      curl -L "$url" -o "$tmp"; \
      mkdir -p "$dest"; \
      tar -xzf "$tmp" -C "$dest" --strip-components=1; \
      rm -f "$tmp"; \
    done

# Canonical, read-only NetVest (works for Docker & Apptainer)
RUN git clone --depth 1 https://github.com/EFForTS-B10/NetVest.git "${NETVEST_HOME}" \
 && find "${NETVEST_HOME}" -type d -exec chmod a+rx {} \; \
 && find "${NETVEST_HOME}" -type f -exec chmod a+r {} \;

# To make a writable copy of NetVest, e.g. for development:    
## mkdir -p "$HOME/NetVest"
## cp -rL /opt/NetVest/. "$HOME/NetVest/"
## or: git clone https://github.com/EFForTS-B10/NetVest.git "$HOME/NetVest"

# ---------- end NetLogo + NetVest ----------

# RStudio server tweak
RUN echo "session-timeout-minutes=0" >> /etc/rstudio/rsession.conf