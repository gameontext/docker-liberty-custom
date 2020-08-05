FROM openliberty/open-liberty:kernel-java8-openj9-ubi

LABEL maintainer="Erin Schnabel <schnabel@us.ibm.com> (@ebullientworks)"

ENV ETCD_VERSION 2.2.2

ENV WLP_SKIP_MAXPERMSIZE=true

USER root
# Workaround, see https://github.com/OpenLiberty/ci.docker/issues/198
RUN rm -rf /var/cache/dnf

# Add basic network diagnosis tools, and curl & wget
# Install etcd client
# Install messagehub login jar
RUN yum --version \
  && yum install iputils net-tools curl wget -y \
  && yum clean all \
  && wget https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -q \
  && tar xzf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz etcd-v${ETCD_VERSION}-linux-amd64/etcdctl --strip-components=1 \
  && rm etcd-v${ETCD_VERSION}-linux-amd64.tar.gz \
  && mv etcdctl /usr/local/bin/etcdctl \
  && wget -O /opt/ol/wlp/usr/servers/defaultServer/messagehub.login-1.0.0.jar \
     https://github.com/ibm-messaging/message-hub-samples/raw/master/java/message-hub-liberty-sample/lib-message-hub/messagehub.login-1.0.0.jar -q

USER 1001
