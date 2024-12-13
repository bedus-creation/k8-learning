FROM ubuntu:22.04

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update package lists and install PHP and other required packages
RUN apt-get update \
    && apt-get install -y \
    gnupg  \
    gosu  \
    curl \
    && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /etc/apt/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/etc/apt/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list

RUN apt-get update \
    && apt-get install -y \
    php8.3-fpm php8.3-cli \
    php8.3-mysql \
    php8.3-mbstring \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the working directory inside the container
WORKDIR /var/www/html
COPY www.conf /etc/php/8.3/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM (optional, for connecting to other services)
EXPOSE 9000

CMD ["php-fpm8.3", "-F"]
