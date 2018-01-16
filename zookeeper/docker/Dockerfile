# Dockerfile for Zookeeper

FROM rocknsm/base:latest
MAINTAINER Derek Ditch <derek@rocknsm.io>

LABEL io.rocknsm.zookeeper="0.0.3"

ENV ROCKNSM_ZOOKEEPER_USER=zookeeper \
    ROCKNSM_ZOOKEEPER_MYID=1 \
    ROCKNSM_ZOOKEEPER_CONFDIR=/etc/zookeeper \
    ROCKNSM_ZOOKEEPER_DATADIR=/var/lib/zookeeper/data \
    ROCKNSM_ZOOKEEPER_DATALOGDIR=/var/lib/zookeeper/logs \
    ROCKNSM_ZOOKEEPER_PORT=2181 \
    ROCKNSM_ZOOKEEPER_TICKTIME=2000 \
    ROCKNSM_ZOOKEEPER_INITLIMIT=10 \
    ROCKNSM_ZOOKEEPER_SYNCLIMIT=5 \
    ROCKNSM_ZOOKEEPER_MAXCLIENTCNXNS=60 \
    ROCKNSM_ZOOKEEPER_SERVERS=server.1=0.0.0.0:2888:3888

ADD zoo.cfg.toml /etc/confd/conf.d/
ADD zoo_myid.toml /etc/confd/conf.d/
ADD zoo.cfg.tmpl /etc/confd/templates/
ADD zoo_myid.tmpl /etc/confd/templates/

# Prepare the environment and get things up to date
RUN yum update -y; \
  yum install -y zookeeper java-1.8.0-openjdk-headless; \
  rm -rf /var/cache/yum/*; \
  mkdir -p "$ROCKNSM_ZOOKEEPER_DATADIR" \
           "$ROCKNSM_ZOOKEEPER_DATALOGDIR"; \
  chown -R "$ROCKNSM_ZOOKEEPER_USER:$ROCKNSM_ZOOKEEPER_USER" \
           "$ROCKNSM_ZOOKEEPER_DATADIR" \
           "$ROCKNSM_ZOOKEEPER_DATALOGDIR"; \
  systemctl enable zookeeper;

# Expose data dirs
VOLUME ["$ROCKNSM_ZOOKEEPER_DATADIR", "$ROCKNSM_ZOOKEEPER_DATALOGDIR"] 
EXPOSE $ROCKNSM_ZOOKEEPER_PORT 2888 3888

# systemd starts by default (from parent)

