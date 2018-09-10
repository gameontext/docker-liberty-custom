FROM openliberty/open-liberty:kernel

LABEL maintainer="Erin Schnabel <schnabel@us.ibm.com> (@ebullientworks)"

ENV ETCD_VERSION 2.2.2

# Remove/avoid extraneous server.env files
ENV WLP_SKIP_MAXPERMSIZE=true

# Ensure up to date / patched OS
RUN  apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade -y \
  && apt-get -qq install -y busybox curl \
  && apt-get -qq clean \
  && rm -rf /tmp/* /var/lib/apt/lists/* \
  && ln -s /bin/busybox /bin/netstat \
  && ln -s /bin/busybox /bin/ping \
  && ln -s /bin/busybox /bin/vi \
  && wget https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -q \
  && tar xzf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz etcd-v${ETCD_VERSION}-linux-amd64/etcdctl --strip-components=1 \
  && rm etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
  && mv etcdctl /usr/local/bin/etcdctl \
  && wget -O /opt/ol/wlp/usr/servers/defaultServer/messagehub.login-1.0.0.jar \
     https://github.com/ibm-messaging/message-hub-samples/raw/master/java/message-hub-liberty-sample/lib-message-hub/messagehub.login-1.0.0.jar -q
