ARG FROM_BASE=${FROM_BASE:-registry.ubuntu.home/docker.io/jenkins/inbound-agent:3283.v92c105e0f819-8-alpine-jdk21}
FROM $FROM_BASE

WORKDIR /tmp
USER root

RUN apk add ca-certificates java-common jq kubectl \
    && wget --no-check-certificate https://s3.ubuntu.home/webdav/home/GIT/Soho-Ball.certs/Soho-Ball_CA/certs.tgz \
    && tar -xzf certs.tgz \
    && mkdir -p /usr/local/share/ca-certificates/ \
    && cp *.crt /usr/local/share/ca-certificates/ \
    && rm /tmp/*

RUN update-ca-certificates -f \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall_CA.crt -file /usr/local/share/ca-certificates/SohoBall_CA.crt \
    && keytool -noprompt -storepass changeit -cacerts -import -alias SohoBall-Server.crt -file /usr/local/share/ca-certificates/SohoBall-Server.crt

USER jenkins
WORKDIR /home/jenkins
