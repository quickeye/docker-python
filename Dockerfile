#######################################
# Docker file to build AMS Application
# Based on Ubuntu
#######################################

# Set the base image to Ubuntu
FROM ubuntu:14.04

# Author / Maintainer
MAINTAINER Rob White

# Update the sources list
RUN apt-get update && apt-get upgrade -y

# Install basic applications
RUN apt-get install -y tar git curl ssh nano wget dialog net-tools build-essential

# Install Python and Basic Python Tools
RUN apt-get install -y python2.7 python2.7-dev python-pip

# Clean up
RUN apt-get autoremove && apt-get clean

# Copy the application folder inside the container
ADD . /ams

# Get pip to download and install requirements
RUN pip install -r /ams/requirements.txt

# Set the default directory where CMD will execute
WORKDIR /ams

# Set the default command to execute
CMD python main.py
