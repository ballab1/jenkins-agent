ARG FROM_BASE=${FROM_BASE:-${DOCKER_REGISTRY}docker.io/jenkins/inbound-agent:3355.v388858a_47b_33-5-alpine-jdk21}
FROM $FROM_BASE

WORKDIR /tmp
USER root
COPY *.sh *.bashlib debugBashScript /usr/bin/
COPY requirements.txt /tmp/

RUN apk add ca-certificates java-common jq kubectl python3 py3-pip \
    && wget --no-check-certificate  https://anonymous@nas.home:5006/GIT/Soho-Ball.certs/Soho-Ball_CA/certs.tgz \
    && tar -xzf certs.tgz \
    && mkdir -p /usr/local/share/ca-certificates/ \
    && cp *.crt /usr/local/share/ca-certificates/ \
    && pip install -r /tmp/requirements.txt --break-system-packages \
    && chmod +x /usr/bin/build.sh /usr/bin/kaniko.sh /usr/bin/update-yaml.sh /usr/bin/debugBashScript \
    && rm /tmp/*

RUN update-ca-certificates -f \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall_CA.crt -file /usr/local/share/ca-certificates/SohoBall_CA.crt \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall-Server.crt -file /usr/local/share/ca-certificates/SohoBall-Server.crt

USER jenkins
WORKDIR /home/jenkins
