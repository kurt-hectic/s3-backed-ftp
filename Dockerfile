FROM phusion/baseimage:master

ENV DEBIAN_FRONTEND=noninteractive

#add this for mustache templates in config files
ADD https://raw.githubusercontent.com/tests-always-included/mo/master/mo /usr/bin/
RUN chmod a+rx /usr/bin/mo

RUN apt-get update && \
    apt-get install -y gosu && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get -y update && apt-get -y install --no-install-recommends \
 automake \
 autotools-dev \
 g++ \ 
 git \ 
 libcurl4-gnutls-dev \
 libfuse-dev \
 libssl-dev \
 libxml2-dev \
 make \
 pkg-config \
 python3-setuptools \
 python3-pip \
 sudo \
 vsftpd \
 openssh-server \
 supervisor \
 && rm -rf /var/lib/apt/lists/*
 
RUN python3 -m pip install awscli

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    ./autogen.sh && \
    ./configure  && \ 
    make && \
    sudo make install

RUN mkdir -p /home/aws/s3bucket/

ADD s3-fuse.sh /usr/local/

ADD vsftpd.conf /etc/vsftpd.conf

RUN chown root:root /etc/vsftpd.conf

ADD sshd_config /etc/ssh/sshd_config

ADD users.sh /usr/local/

ADD add_users_in_container.sh /usr/local/

RUN echo "/usr/sbin/nologin" >> /etc/shells

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 21 22 

CMD ["/usr/bin/supervisord"]
