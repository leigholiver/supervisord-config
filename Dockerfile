FROM alpine:3.15

RUN apk add --no-cache php-fpm php-cli nginx supervisor
RUN adduser -D supervisor-user

COPY supervisor /etc/supervisor
COPY worker.php /worker.php
COPY docker-entrypoint.sh /docker-entrypoint.sh


CMD ["/docker-entrypoint.sh"]
