# Jenkins Framework

## Quick Start
This is a local stack framework for a Jenkins/Worker environment. 

### Build Docker-Compose
There are three continers contained in the YAML file.<br/> 
Services:
```
    ├── jenkins-manager             # Jenkins Manager/Master for coordination of jobs
    ├── jenkins-worker              # Jenkins worker for running jobs
    └── admin-host                  # Adminstrator container for testing communication between containers
```
The following command uses the stage environment variables.

```
docker-compose -f docker-compose.yaml --env-file envs/stage.env build --no-cache
```

### Run Docker-Compose
```
docker-compose -f docker-compose.yaml --env-file envs/stage.env up
```

### Access Container
There are three containers jenkins-manager, jenkins-worker, admin-host. To access any of the containers you can run the following command.
```
docker exec -it <container> /bin/bash
```

### Folder Structure
```
.
├── /casc                   # Location of Jenkins Configuration
├── /dockerfile             # Location of main dockerfile
├── /envs                   # Location of Container system environments
├── /examples               # Location of sample pipeline and multibranch pipeline jobs
├── /git                    # Location where config, ssh_key files should be located
├── /plugins                # Location of Jenkins plugin list
├── README.MD               # Document about repo
└── docker-compose.yaml     # Docker compose file
```

## Configuration Files

### System Environments
The 'envs' folder contains environment variables that gets used when the container is being built and also provide system environment variables that can be used by Jenkins. There should be a file for each environment (e.g. production.env, dev.env, ...)
```
BUILD_ENV                   # What Build Environment are these variables going to be used for
ENV_CASC                    # Location of the Jenkins configuration as code file
ENV_PLUGINS                 # Location of the Jenkins plugins list file
ENV_GIT_CONFIG              # Location of the Git configuration file
ENV_GIT_KEY                 # Location of the private ssh key used to access the repository
```
### Docker-Compose
The docker-compose.yaml file is the main orchestration file to build the Jenkins container. This is located in the root directory.
```
build: Contains the location of the dockerfile that is currently being used.
args: Referenced from the system environment file used when building the container.
ports: What available ports are currently accesible.
```
### Dockerfile
The 'dockerfile' folder houses manager, worker, and admin dockerfiles.

```
DOCKER BUILD: Build and Artifacts that impact the container during build.
DOCKER UP: System variables added to the container while running.
```
### Git
The 'git' folder contains any files needed for Jenkins to access the Git repository. By default there is a configuration file that has 'StrictHostKeyChecking' set to no. This allows Jenkins to bypass the yes/no authorization when first contacting with Git on a new system. The system environment file requires the following files:
```
.
├── config
└── id_rsa
```
** If id_rsa file is missing, either add private key to the folder or comment the manager dockerfile to ignore the file. **
### Plugins
The 'plugins' folder should contain a plugin file or each corresponding system environment. If a Jenkins sytem is up and not sure about which plugins are being used or want to create a plugins list run the following code in Jenkins Script Console.
```
Jenkins.instance.pluginManager.plugins.each{plugin ->println ("${plugin.getShortName()}")}
```
### Jenkins Configuration as Code
The 'casc' folder should contain a Jenkins configuration file for each corresponding system environment. 
For additional information about Jenkins Configuration as Code: https://github.com/jenkinsci/configuration-as-code-plugin

### Examples
The 'examples' folder seeds an example pipeline job attached that gets ran on the jenkins-worker.