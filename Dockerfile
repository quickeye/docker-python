#######################################
# Docker file to build AMS Application
# Based on Ubuntu
#######################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# Author / Maintainer
MAINTAINER Rob White

# Update the sources list and install basic applications
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  tar \
  git \
  curl \
  ssh \
  nano \
  wget \
  dialog \
  net-tools \
  build-essential \
  python2.7 \
  python2.7-dev \
  python-pip \
  unixodbc-dev

# Clean up
RUN apt-get autoremove && apt-get clean

# Copy the application folder inside the container
WORKDIR /ams
COPY requirements.txt /ams

# Get pip to download and install requirements
RUN pip install -r /ams/requirements.txt

# Set the default command to execute
CMD ["python","main.py"]
