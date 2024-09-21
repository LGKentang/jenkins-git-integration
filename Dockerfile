# Use the official Jenkins LTS image as the base image
FROM jenkins/jenkins:lts

# Switch to root user to install additional packages
USER root

# Install necessary packages (e.g., Docker client, Git)
RUN apt-get update && \
    apt-get install -y \
        docker.io \
        git \
        sudo \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Jenkins plugins (you can customize this list)
RUN jenkins-plugin-cli --plugins \
        git \
        docker-workflow \
        pipeline-stage-view \
        blueocean \
        workflow-aggregator

# Switch back to the Jenkins user
USER jenkins

# Expose ports (you can adjust these as needed)
EXPOSE 8081 50000

# Set the default command to run Jenkins
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]


FROM pierrezemb/gostatic
COPY . /srv/http/
CMD ["-port","8080","-https-promote", "-enable-logging"]
