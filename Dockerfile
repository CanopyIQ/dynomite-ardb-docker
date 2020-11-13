FROM openjdk:8-slim-buster
LABEL maintainer="Samiur Rahman - me@samiurr.com"

RUN apt-get update && apt-get install -y \
	autoconf \
	build-essential \
	dh-autoreconf \
	git \
	libssl-dev \
	libtool \
	software-properties-common \
  wget \
	dos2unix \
	unzip

WORKDIR /
RUN git clone -b 'v0.6.12' --single-branch --depth 1 https://github.com/Netflix/dynomite.git

RUN git clone https://github.com/yinqiwen/ardb.git --single-branch --depth 1 && cd /ardb/ &&  storage_engine=lmdb make CXX='g++ -w'

COPY single.yml /dynomite/conf/single.yml

WORKDIR /dynomite/
RUN autoreconf -fvi \
		&& ./configure --enable-debug=log \
		&& CFLAGS="-ggdb3 -O0" ./configure --enable-debug=log \
		&& make \
		&& make install

EXPOSE 8101
EXPOSE 16379
EXPOSE 22222
EXPOSE 8102

ADD start.sh /usr/local/dynomite/

RUN chmod +x /usr/local/dynomite/start.sh

COPY ardb.conf /ardb/src/ardb.conf

# https://circleci.com/docs/2.0/high-uid-error/
RUN chown -R root:root /ardb

VOLUME /ardb/src/data

CMD ["/usr/local/dynomite/start.sh"]
