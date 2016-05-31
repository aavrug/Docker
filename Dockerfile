FROM ubuntu:14.04

MAINTAINER Gaurav Kumar <aavrug@gmail.com>

#Set the Environment
ENV DEBIAN_FRONTEND=noninteractive

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN apt-get update && apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl curl lynx-cur php5-intl php5-mcrypt 
RUN curl -sS https://getcomposer.org/installer | php
RUN sudo mv composer.phar /usr/local/bin/composer

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 3000

# Copy site into place.
COPY src/ /var/www/html/

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

#Install plugins via composer
RUN cd /var/www/html/docker && composer install
 
#Add permissions to tmp and logs
RUN chmod -R 777 /var/www/html/docker/logs /var/www/html/docker/tmp

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
