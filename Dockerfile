FROM i386/debian:8 AS base

RUN set -eux; \
    printf '%s\n' \
        'deb http://archive.debian.org/debian jessie main contrib non-free' \
        'deb http://archive.debian.org/debian-security jessie/updates main contrib non-free' \
        > /etc/apt/sources.list; \
    printf 'Acquire::Check-Valid-Until "false";\n' > /etc/apt/apt.conf.d/99archive; \
    useradd --create-home --home-dir /home/nwn --shell /bin/bash nwn; \
    mkdir -p /var/www/thalie/data /home/nwn/src; \
    chown -R nwn:nwn /home/nwn /var/www/thalie

FROM base AS builder

COPY scripts/build-nwnx.sh /usr/local/bin/build-nwnx.sh

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --force-yes \
        build-essential \
        ca-certificates \
        cmake \
        g++ \
        gcc \
        gdb \
        git \
        libmysqlclient-dev \
        gperf \
        make \
        sudo \
        vim; \
    rm -rf /var/lib/apt/lists/*; \
    echo 'nwn ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nwn; \
    chmod 0755 /usr/local/bin/build-nwnx.sh

WORKDIR /home/nwn/src
USER nwn

CMD ["/bin/bash"]

FROM base AS runtime

COPY nwserver.tgz /tmp/nwserver.tgz

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends --force-yes \
        ca-certificates \
        gdb \
        libmysqlclient18 \
        libstdc++6 \
        mariadb-client \
        psmisc \
        procps \
        vim \
        zlib1g; \
    rm -rf /var/lib/apt/lists/*; \
    tar -xzf /tmp/nwserver.tgz -C /home/nwn; \
    rm -f /tmp/nwserver.tgz; \
    chown -R nwn:nwn /home/nwn

WORKDIR /home/nwn
USER nwn

CMD ["/bin/bash"]
