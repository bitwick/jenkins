# For new versions visit https://hub.docker.com/r/jenkins/jenkins/tags
FROM jenkins/jenkins:latest

########################################################################
### DOCKER BUILD 
########################################################################

# Values pulled from docker-compose file
ARG PLUGINS
ARG CASC
ARG BUILD_ENV
ARG ENV_GIT_CONFIG
ARG ENV_GIT_KEY
ARG JOB_EXAMPLES

# Install plugins
COPY --chown=jenkins:jenkins ${PLUGINS} ${REF}/plugins.txt
RUN /usr/local/bin/install-plugins.sh < ${REF}/plugins.txt

# Configuration as Code
RUN mkdir ${REF}/casc_configs
COPY --chown=jenkins:jenkins ${CASC} ${REF}/casc_configs/jenkins.yaml

# Copy and Set Permissions for GIT SSH Key
RUN mkdir -p ${REF}/.ssh
RUN chmod 0700 ${REF}/.ssh
COPY --chown=jenkins:jenkins ${ENV_GIT_CONFIG} ${REF}/.ssh/config
COPY --chown=jenkins:jenkins ${ENV_GIT_KEY} ${REF}/.ssh/id_rsa
RUN chmod 600 ${REF}/.ssh/id_rsa

# Copy Jobs
RUN mkdir ${REF}/jobs
COPY --chown=jenkins:jenkins ${JOB_EXAMPLES} ${REF}/jobs

########################################################################
### DOCKER UP
########################################################################

# Values set in container when running
ARG JAVA_OPTS
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
ENV CASC_JENKINS_CONFIG ${REF}/casc_configs
ENV BUILD_ENV ${BUILD_ENV}



