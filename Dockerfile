FROM php:5.6-apache

MAINTAINER Gaurav Kumar <aavrug@gmail.com>

COPY src/ /var/www/html/

EXPOSE 3000

RUN sed -i 's/Listen 80/Listen 3000/' /etc/apache2/apache2.conf

# No assets yet. Fix this when compilation happens
RUN mkdir -p /app/public/Docker
