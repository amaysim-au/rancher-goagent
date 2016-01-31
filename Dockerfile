FROM rawmind/rancher-jvm8:0.0.2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

# Set environment
ENV GOCD_REPO=https://download.go.cd/gocd/ \
  GOCD_RELEASE=go-agent-15.3.1 \
  GOCD_REVISION=2777 \
  GOCD_HOME=/opt/go-agent \
  DOCKER_VERSION=1.9.1 \
  PATH=$GOCD_HOME:$PATH
ENV GOCD_RELEASE_ARCHIVE ${GOCD_RELEASE}-${GOCD_REVISION}.zip

# Install and configure gocd
RUN apk add --update git && rm -rf /var/cache/apk/* \
  && mkdir /var/log/go-agent /var/run/go-agent \
  && cd /opt && curl -sSL ${GOCD_REPO}/${GOCD_RELEASE_ARCHIVE} -O && unzip ${GOCD_RELEASE_ARCHIVE} && rm ${GOCD_RELEASE_ARCHIVE} \
  && ln -s /opt/${GOCD_RELEASE} ${GOCD_HOME} \
  && chmod 774 ${GOCD_HOME}/*.sh \
  && mkdir -p ${GOCD_HOME}/work \
  && cd /tmp && curl https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION} -O && mv /tmp/docker-${DOCKER_VERSION} /usr/bin/docker

WORKDIR ${GOCD_HOME}

ENTRYPOINT ["/opt/go-agent/agent.sh"]