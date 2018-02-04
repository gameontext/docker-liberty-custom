FROM websphere-liberty:kernel

LABEL maintainer="Erin Schnabel <schnabel@us.ibm.com> (@ebullientworks)"

ENV ETCD_VERSION 2.2.2

# Ensure up to date / patched OS
RUN  apt-get -qq update \
  && apt-get -qq install -y curl \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade -y \
  && apt-get -qq clean \
  && rm -rf /tmp/* /var/lib/apt/lists/*

# setup etcd
RUN wget https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -q \
  && tar xzf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz etcd-v${ETCD_VERSION}-linux-amd64/etcdctl --strip-components=1 \
  && rm etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
  && mv etcdctl /usr/local/bin/etcdctl

# Install required features
# Note: we're accepting license here, as per: https://docs.docker.com/samples/library/websphere-liberty/
RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense \
      apiDiscovery-1.0 \
      cdi-1.2 \
      concurrent-1.0 \
      couchdb-1.0 \
      localConnector-1.0 \
      jaxrs-2.0 \
      jndi-1.0 \
      jsonp-1.0 \
      ssl-1.0 \
      websocket-1.1
