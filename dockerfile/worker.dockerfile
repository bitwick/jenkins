# Latest Image
FROM ubuntu:latest

########################################################################
### DOCKER BUILD 
########################################################################

ARG ENV_GIT_CONFIG
ARG ENV_GIT_KEY

# Set Container Timzeone - REQUIRED to automate the installation of openssh-server
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update and Install Packages
RUN apt-get update && \
    apt-get -qy full-upgrade && \
    apt-get install -qy apt-utils git openssh-server openjdk-8-jdk python3 python3-pip maven && \
    apt-get -qy autoremove

# Set Worker SSH Account and password 
RUN adduser --quiet jenkins
RUN echo "jenkins:jenkins" | chpasswd

# SSH Configuration
# Change Required to Optional for PAM login UID
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd && mkdir -p /home/jenkins/.ssh
RUN chown -R jenkins:jenkins /home/jenkins/.ssh/
EXPOSE 22

# Copy and Set Permissions for GIT SSH Key
COPY --chown=jenkins:jenkins ${ENV_GIT_CONFIG} /home/jenkins/.ssh/config
COPY --chown=jenkins:jenkins ${ENV_GIT_KEY} /home/jenkins/.ssh/id_rsa
RUN chmod 600 /home/jenkins/.ssh/id_rsa
RUN chmod 600 /home/jenkins/.ssh/config

########################################################################
### DOCKER UP
########################################################################

# Run SSH Deamon
CMD ["/usr/sbin/sshd", "-D"]