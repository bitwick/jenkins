# Latest Image
FROM ubuntu:latest

########################################################################
### DOCKER BUILD 
########################################################################

# Set Container Timzeone - REQUIRED to automate the installation of openssh-server
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and Install Packages
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get -qy install net-tools openssh-client iputils-ping && \
    apt-get -qy autoremove