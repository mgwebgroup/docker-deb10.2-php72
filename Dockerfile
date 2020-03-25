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
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

COPY 010-default.conf /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]
ENTRYPOINT ["docker-php-entrypoint"]
