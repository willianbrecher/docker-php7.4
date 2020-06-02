FROM php:7.4-apache

LABEL author="Willian Brecher"
LABEL email="willian.brecher@gmail.com"

RUN apt-get update 

# COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer        

# HABILITA MODO REQRITE NO APACHE
RUN a2enmod rewrite

# LDAP
RUN apt-get update && \
        apt-get install -y libldap2-dev && \
        rm -rf /var/lib/apt/lists/* && \
        docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
        docker-php-ext-install ldap

# PGSQL
RUN apt-get update && \
        apt-get install -y libpq-dev \
        && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
        && docker-php-ext-install pdo pdo_pgsql pgsql            

# SOAP 
RUN apt-get install -y libxml2-dev && docker-php-ext-install soap

# CURL
RUN apt-get install -y libcurl4-gnutls-dev && docker-php-ext-install curl

RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev \
    && apt-get install -y libpng-dev    

# GD 
RUN docker-php-ext-install gd

#OPCACHE
RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache

# TIMESTAMP
RUN printf '[PHP]\ndate.timezone = "America/Sao_Paulo"\n' > /usr/local/etc/php/conf.d/tzone.ini

# INICIAR AUTOMATICAMENTE OS SERVIÇOS
CMD /etc/init.d/memcached start && /etc/init.d/apache2 start ; while true ; do sleep 100; done;