FROM alpine:3.5
MAINTAINER Gervasio Marchand <gmc@gmc.uy>
ENV build_date 2017-03-22 12:18

RUN apk add --update python python-dev py2-pip build-base git supervisor redis bash && \
    pip install virtualenv && \
    rm -rf /var/cache/apk/*

RUN git clone https://github.com/g3rv4/retweeter.git /var/retweeter && \
    virtualenv /var/retweeter/env && \
    /var/retweeter/env/bin/pip install --no-cache-dir -r /var/retweeter/requirements.txt

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY redis.conf /etc/redis.conf

VOLUME ["/var/db"]

WORKDIR /var/retweeter
EXPOSE 8000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
