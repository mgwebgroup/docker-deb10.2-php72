FROM phpstorm/php-72-apache-xdebug-27

# docker scripts which install php extensions are in /usr/local/bin
RUN apt-get update
RUN apt-get -y autoremove
RUN apt-get -y install libpng-dev libxml2-dev libxslt1-dev libfreetype6-dev
# php extensions are compiled from source files stored in /usr/src/php
RUN /usr/local/bin/docker-php-ext-configure gd --with-freetype-dir=/usr/lib/x86_64-linux-gnu
RUN /usr/local/bin/docker-php-ext-install gd soap pdo_mysql bcmath intl xsl zip sockets
RUN echo 'memory_limit=1G' >> /usr/local/etc/php/php.ini

RUN apt-get -y install git less nano telnet iputils-ping
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'c5b9b6d368201a9db6f74e2611495f369991b72d9c8cbd3ffbc63edff210eb73d46ffbfce88669ad33695ef77dc76976') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

CMD ["apache2-foreground"]
ENTRYPOINT ["docker-php-entrypoint"]