FROM ubuntu:16.04
MAINTAINER zouyapeng <zyp19901009@163.com>

ENV \
    SENSU_VERSION=0.26.5-2 \
    DUMB_INIT_VERSION=1.2.0 \
    ENVTPL_VERSION=0.2.3 \
    PATH=/opt/sensu/embedded/bin:$PATH

RUN \
    apt-get update && \
    apt-get install -y curl ca-certificates --no-install-recommends && \
    wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | sudo apt-key add - && \
    echo "deb     https://sensu.global.ssl.fastly.net/apt sensu main" | sudo tee /etc/apt/sources.list.d/sensu.list && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

RUN \
    apt-get update && \
    apt-get install -y sensu=${SENSU_VERSION} && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

RUN \
    curl -Ls https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb > dumb-init.deb && \
    dpkg -i dumb-init.deb && \
    rm dumb-init.deb

RUN \
    curl -Ls https://github.com/arschles/envtpl/releases/download/${ENVTPL_VERSION}/envtpl_linux_amd64 > /usr/local/bin/envtpl && \
    chmod +x /usr/local/bin/envtpl

EXPOSE 4567
VOLUME ["/etc/sensu/conf.d"]

ENTRYPOINT ["/usr/bin/dumb-init", "--", "ensu-server"]
