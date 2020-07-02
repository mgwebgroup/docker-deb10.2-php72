FROM phpstorm/php-72-apache-xdebug-27


RUN apt-get update
RUN apt-get -y autoremove
RUN apt-get -y install libpng-dev libxml2-dev libxslt1-dev libfreetype6-dev
# docker scripts which install php extensions are in /usr/local/bin
# php extensions are compiled from source files stored in /usr/src/php
RUN /usr/local/bin/docker-php-ext-configure gd --with-freetype-dir=/usr/lib/x86_64-linux-gnu
RUN /usr/local/bin/docker-php-ext-install gd soap pdo_mysql bcmath intl xsl zip sockets
RUN echo 'memory_limit=1G' >> /usr/local/etc/php/php.ini

RUN apt-get -y install git less nano telnet iputils-ping gnupg wget iptables

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -y install yarn

COPY composer-install.sh /opt/
RUN /opt/composer-install.sh

COPY 010-default.conf /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]
ENTRYPOINT ["docker-php-entrypoint"]
