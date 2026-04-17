ARG FROM_BASE=${FROM_BASE:-${DOCKER_REGISTRY}docker.io/jenkins/inbound-agent:3355.v388858a_47b_33-5-alpine-jdk21}
FROM $FROM_BASE

LABEL Maintainers="bobb@k8s.home"
LABEL Version="1.0"
LABEL Description="java agent with basic support for creating other containers"

# Set the environments
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


WORKDIR /tmp
USER root
COPY *.sh *.bashlib debugBashScript /usr/bin/
COPY requirements.txt /tmp/

RUN apk add --no-cache ca-certificates gcc git java-common jq kubectl libffi-dev librdkafka-dev musl-dev python3 py3-pip \
    && wget --no-check-certificate  https://anonymous@nas.home:5006/GIT/Soho-Ball.certs/Soho-Ball_CA/certs.tgz \
    && tar -xzf certs.tgz \
    && mkdir -p /usr/local/share/ca-certificates/ \
    && cp *.crt /usr/local/share/ca-certificates/ \
    && pip install --no-cache-dir -r /tmp/requirements.txt --break-system-packages \
    && chmod +x /usr/bin/build.sh /usr/bin/update-yaml.sh /usr/bin/debugBashScript \
    && rm /tmp/*

RUN update-ca-certificates -f \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall_CA.crt -file /usr/local/share/ca-certificates/SohoBall_CA.crt \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall-Server.crt -file /usr/local/share/ca-certificates/SohoBall-Server.crt

USER jenkins
WORKDIR /home/jenkins
