FROM postgres:12

LABEL maintainer="hackershare - https://hackershare.dev"

ENV SCWS_VERSION 1.2.3
ENV RUM_VERSION 1.3.7
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget \
    && apt-get install -y tar make gcc \
    && apt-get install -y postgresql-server-dev-$PG_MAJOR \
    && mkdir build \
    && cd build \
    && wget -q -O - http://www.xunsearch.com/scws/down/scws-$SCWS_VERSION.tar.bz2 | tar xjf -  \
    && cd scws-$SCWS_VERSION ; ./configure ; make install \
    && cd .. \
    && rm -rf scws-$SCWS_VERSION \
    && wget -q --no-check-certificate -O - https://github.com/amutu/zhparser/archive/master.tar.gz | tar xzf - \
    && cd zhparser-master ; SCWS_HOME=/usr/local make && make install ; cd .. \
    && rm -rf zhparser-master 

RUN wget -q -O - https://github.com/postgrespro/rum/archive/$RUM_VERSION.tar.gz |tar zxvf - \
    && cd rum-$RUM_VERSION \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && cd .. \
    && rm -rf rum-$RUM_VERSION \
    && apt-get purge -y --auto-remove ca-certificates wget postgresql-server-dev-$PG_MAJOR make gcc