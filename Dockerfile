# Jupyter version 2c80cf3537ca (Dec. 30, 2017)
FROM jupyter/minimal-notebook:2c80cf3537ca

LABEL maintainer="Anastasios Skarlatidis"

# -----------------------------------------------------------------------------
# --- Constants
# -----------------------------------------------------------------------------

# Set the desired version of jupyter-scala
ENV JUPYTER_SCALA_VERSION="0.4.2"

# Set the desired version of SBT
ENV SBT_VERSION="0.13.15"

# -----------------------------------------------------------------------------
# --- Install depenencies (distro packages)
# -----------------------------------------------------------------------------

USER root

# Install software-properties and curl
RUN \
  apt-get update \
  && apt-get install -y software-properties-common python-software-properties \
  && apt-get install -y curl \
  && apt-get install -y openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

# Define JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/openjdk-8
ENV PATH=${PATH}:${JAVA_HOME}/bin

# -----------------------------------------------------------------------------
# --- Download and install Jupyter-Scala, the Llightweight Scala kernel for 
# --- Jupyter / IPython 3. 
# --- For details, see https://github.com/jupyter-scala/jupyter-scala
# -----------------------------------------------------------------------------

# Download SBT
RUN curl -sL --retry 5 "https://github.com/sbt/sbt/releases/download/v0.13.15/sbt-0.13.15.tgz" \
  | gunzip \
  | tar -x -C "/tmp/" \
  && mv "/tmp/sbt" "/opt/sbt-${SBT_VERSION}" \
  && chmod +x "/opt/sbt-${SBT_VERSION}/bin/sbt"

ENV PATH=${PATH}:/opt/sbt-${SBT_VERSION}/bin/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

# Download jupyter-scala
RUN curl -sL --retry 5 "https://github.com/almond-sh/almond/archive/jupyter-scala-v${JUPYTER_SCALA_VERSION}.tar.gz" \
  | gunzip \
  | tar -x -C "/tmp/" 

# Build jupyter-scala for Scala 2.11 and 2.12
RUN cd "/tmp/almond-jupyter-scala-v${JUPYTER_SCALA_VERSION}" && \
  /opt/sbt-${SBT_VERSION}/bin/sbt ++2.11.11 ++2.12.2 publishLocal

# Install kernel for Scala 2.11
RUN cd /tmp/almond-jupyter-scala-v${JUPYTER_SCALA_VERSION}/ \
  && ./jupyter-scala --id scala_2_11 --name "Scala (2.11)" --force

# Install kernel for Scala 2.12
RUN cd /tmp/almond-jupyter-scala-v${JUPYTER_SCALA_VERSION}/ \
  && sed -i 's/\(SCALA_VERSION=\)\([2-9]\.[0-9][0-9]*\.[0-9][0-9]*\)\(.*\)/\12.12.2\3/' jupyter-scala \
  && ./jupyter-scala --id scala_2_12 --name "Scala (2.12)" --force
  
RUN rm -r /tmp/almond-jupyter-scala-v${JUPYTER_SCALA_VERSION}/

RUN rm -r /home/$NB_USER/.sbt/*
RUN rm -r /home/$NB_USER/.ivy2/*
RUN rm -r /home/$NB_USER/.ivy2/.sbt*
RUN rm -r /home/$NB_USER/.coursier/*

WORKDIR /home/$NB_USER/work