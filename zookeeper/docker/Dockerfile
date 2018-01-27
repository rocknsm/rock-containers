# Dockerfile for Zookeeper

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.zookeeper="0.0.6"

ENV ZOOKEEPER_USER=zookeeper \
    ZOOKEEPER_MYID=1 \
    ZOOKEEPER_CONFDIR=/etc/zookeeper \
    ZOOKEEPER_DATADIR=/var/lib/zookeeper/data \
    ZOOKEEPER_DATALOGDIR=/var/lib/zookeeper/logs \
    ZOOKEEPER_PORT=2181 \
    ZOOKEEPER_TICKTIME=2000 \
    ZOOKEEPER_INITLIMIT=10 \
    ZOOKEEPER_SYNCLIMIT=5 \
    ZOOKEEPER_MAXCLIENTCNXNS=60 \
    ZOOKEEPER_SERVERS=server.1=0.0.0.0:2888:3888

# Prepare the environment and get things up to date
RUN yum update -y; \
  yum install -y zookeeper java-1.8.0-openjdk-headless; \
  rm -rf /var/cache/yum/*; \
  mkdir -p "$ZOOKEEPER_DATADIR" \
           "$ZOOKEEPER_DATALOGDIR"; \
  chown -R "$ZOOKEEPER_USER:$ZOOKEEPER_USER" \
           "$ZOOKEEPER_DATADIR" \
           "$ZOOKEEPER_DATALOGDIR"; \
  systemctl enable zookeeper;

# Add configuration templates
COPY zoo.cfg.toml /etc/confd/conf.d/
COPY zoo_myid.toml /etc/confd/conf.d/
COPY zoo.cfg.tmpl /etc/confd/templates/
COPY zoo_myid.tmpl /etc/confd/templates/


# Expose data dirs
VOLUME ["$ZOOKEEPER_DATADIR", "$ZOOKEEPER_DATALOGDIR"] 
EXPOSE $ZOOKEEPER_PORT 2888 3888

# systemd starts by default (from parent)

