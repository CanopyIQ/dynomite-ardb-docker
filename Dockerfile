FROM java:8-jdk
MAINTAINER Samiur Rahman - me@samiurr.com

RUN apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	dh-autoreconf \
	git \
	libssl-dev \
	libtool \
	python-software-properties \
	tcl8.5 \
	dos2unix \
	unzip

WORKDIR /opt

RUN git clone https://github.com/Netflix/dynomite.git
RUN cd dynomite/ && git checkout tags/v0.6.7
RUN cd dynomite/ && autoreconf -fvi \
		&& ./configure --enable-debug=log \
		&& CFLAGS="-ggdb3 -O0" ./configure --enable-debug=log \
		&& make \
		&& make install

RUN git clone https://github.com/yinqiwen/ardb.git
RUN cd ardb/ && storage_engine=lmdb make

RUN mkdir /var/log/ardb && mkdir /var/log/dynomite

ADD start.sh /opt/dynomite/

RUN chmod +x /opt/dynomite/start.sh

COPY single.yml /opt/dynomite/conf/dynomite.yml
COPY ardb.conf /opt/ardb/ardb.conf

VOLUME /ardb/src/data

EXPOSE 8101
EXPOSE 16379
EXPOSE 22222
EXPOSE 8102

CMD ["/opt/dynomite/start.sh"]