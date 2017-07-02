FROM armv7/armhf-ubuntu:16.10
MAINTAINER Christopher Langton <chris@devopsatscale.com.au>

ARG PASSWD=changeme
ARG AUTH=c9:ide
ARG PORT=8080
ARG APP_PORT=3000

ENV AUTH ${AUTH}
ENV PORT ${PORT}
ENV APP_PORT ${APP_PORT}

# Install dependencies
RUN apt-get update && apt-get install --yes \
    build-essential \
    g++ \
    curl \
    libssl-dev \
    apache2-utils \
    git \
    libxml2-dev \
    sshfs \
    python2.7

RUN ln -s /usr/bin/python2.7 /usr/bin/python

# Add cloud9ide user
RUN useradd --create-home --shell /bin/bash cloud9ide
RUN echo "cloud9ide:$PASSWD" | chpasswd

# Install cloud9ide
RUN runuser -l cloud9ide -c 'git clone https://github.com/c9/core.git /home/cloud9ide/cloud9'
RUN runuser -l cloud9ide -c '/home/cloud9ide/cloud9/scripts/install-sdk.sh'

# Update config
RUN runuser -l cloud9ide -c "sed -i -e 's_127.0.0.1_0.0.0.0_g' /home/cloud9ide/cloud9/configs/standalone.js"

# Add workspace directory
RUN mkdir /workspace && \
    chown cloud9ide /workspace
WORKDIR /workspace

# Install Node.js 8
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update && apt-get install --yes nodejs

# Install Go 1.8
ADD https://storage.googleapis.com/golang/go1.8.linux-armv6l.tar.gz /usr/local
RUN ln -s /usr/local/go/bin/go /usr/bin/go

# Cleanup apt-get
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Expose ports: Note dont use port 80 - node is not run as root
EXPOSE ${PORT}
EXPOSE ${APP_PORT}

# Setup entrypoint
USER cloud9ide
CMD ["/home/cloud9ide/.c9/node/bin/node","/home/cloud9ide/cloud9/server.js","--auth","$AUTH","--listen","0.0.0.0","--port","$PORT","-w","/workspace"]
