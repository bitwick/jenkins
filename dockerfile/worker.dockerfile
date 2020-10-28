# Latest Image
FROM ubuntu:latest

########################################################################
### DOCKER BUILD 
########################################################################

ARG ENV_GIT_CONFIG
ARG ENV_GIT_KEY
ARG JENKINS_HOME_SSH
ENV JENKINS_HOME_SSH /home/jenkins/.ssh
# Set Container Timzeone - REQUIRED to automate the installation of openssh-server
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get -qy install git  && \
    apt-get -qy install openssh-server && \
    apt-get -qy install openjdk-8-jdk  maven && \
    apt-get -qy install python3 python3-pip && \
    apt-get -qy install sudo && \
    apt-get -qy autoremove

# Set Worker SSH Account and password 
RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd

# SSH Configuration
# Change Required to Optional for PAM login UID
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd && mkdir -p ${JENKINS_HOME_SSH}
RUN chown -R jenkins:jenkins ${JENKINS_HOME_SSH}
EXPOSE 22

# Copy and Set Permissions for GIT SSH Key
COPY --chown=jenkins:jenkins ${ENV_GIT_CONFIG} ${JENKINS_HOME_SSH}/config
COPY --chown=jenkins:jenkins ${ENV_GIT_KEY} ${JENKINS_HOME_SSH}/id_rsa
RUN chmod 600 ${JENKINS_HOME_SSH}/id_rsa
RUN chmod 600 ${JENKINS_HOME_SSH}/config

########################################################################
### DOCKER UP
########################################################################

# Run SSH Deamon
CMD ["/usr/sbin/sshd", "-D"]