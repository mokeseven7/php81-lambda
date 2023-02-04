#Lambda base image Amazon linux
FROM public.ecr.aws/lambda/provided as builder

#######################  REFERENCES:

## Aws
# https://aws.amazon.com/blogs/apn/aws-lambda-custom-runtime-for-php-a-practical-example/

## Amazon Linux Lambda runtime environment:
# https://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html

## Php release page and download links
# http://php.net/downloads.php  <- page to find updated versions of php

## ZipLib:
# https://libzip.org/

## FreeType Downloads
# https://www.freetype.org/download.html

COPY installation/update_os.sh /opt/installation/update_os.sh
RUN yum update -y && \
    yum install -y git gzip jq tar unzip vim wget zip

RUN /opt/installation/update_os.sh

# Download: https://www.openssl.org/source/
#ENV OPENSSL_VERSION 1.0.2t
# 9580 	2020-Sep-22 13:11:49 	openssl-1.1.1h.tar.gz (SHA256) (PGP sign) (SHA1)
#ENV OPENSSL_VERSION 1.1.1h
# 9593 	2021-Mar-25 13:41:15 	openssl-1.1.1k.tar.gz (SHA256) (PGP sign) (SHA1)
#ENV OPENSSL_VERSION 1.1.1m
#ENV OPENSSL_VERSION 1.1.1o

ENV OPENSSL_VERSION 3.0.3


# Download http://ftp.gnu.org/gnu/bison/
#ENV BISON_VERSION 3.7
# bison-3.7.4.tar.gz	2020-11-14 06:33	4.7M
# bison-3.7.6.tar.gz	2021-03-09 02:23	4.7M
#ENV BISON_VERSION 3.7.4
ENV BISON_VERSION 3.8.2


# Download https://pecl.php.net/package/memcached                     side note:  is this project dead?
# 3.1.5	stable	2019-12-03	memcached-3.1.5.tgz (81.1kB)
#ENV MEMCACHED_VERSION 3.1.5
ENV MEMCACHE_VERSION 8.0
#http://pecl.php.net/get/memcache-8.0.tgz

# Download: https://github.com/Kitware/CMake/releases
#ENV CMAKE_VERSION 3.18.3
# https://github.com/Kitware/CMake/releases/tag/v3.18.5   Released Nov 18, 2020
#ENV CMAKE_VERSION 3.18.5
# https://github.com/Kitware/CMake/releases/tag/v3.20.2   Released April 29, 2021
#ENV CMAKE_VERSION 3.20.2
ENV CMAKE_VERSION 3.22.5

# Download: https://libzip.org/news/
# Released libzip 1.7.3 - July 15, 2020
#ENV LIBZIP_VERSION 1.7.3
# Released libzip 1.8.0 - June 18, 2021
ENV LIBZIP_VERSION 1.8.0


#old FREETYPE 2.10.1
# Download: https://sourceforge.net/projects/freetype/
#ENV FREETYPE_VERSION 2.10.2
# Release 2.10.4 - Released October 2020
ENV FREETYPE_VERSION 2.10.4
# Release 2.12.1 - Last Update: 2022-05-01
ENV FREETYPE_VERSION 2.12.1


## PHPREDIS: Download Versions: https://github.com/phpredis/phpredis/tags
ENV PHPREDIS_VERSION 5.3.4
## 5.3.7 - on Feb 15
ENV PHPREDIS_VERSION 5.3.7


ENV PHP_VERSION 8.1.11
ENV PHP_SHA256 3660e8408321149f5d382bb8eeb9ea7b12ea8dd7ea66069da33f6f7383750ab2

COPY opt/ /opt
RUN cd /opt/downloads && ./download_packages.sh
RUN cd /opt/downloads && ./install_packages.sh
RUN /opt/build/install_openssl.sh
RUN /opt/build/install_tools.sh

RUN yum install -y sqlite-devel

RUN cd /opt/php-${PHP_VERSION} && \
    ./buildconf --force && \
    LD_LIBRARY_PATH=/opt/lib64 ./configure --prefix=/root/php-bin/ \
        --with-libdir=lib64 \
        --disable-shared \
        --with-config-file-path=/opt/ini \
        --with-config-file-scan-dir=/var/task/ini.d \
        --with-system-ciphers --enable-gd --with-freetype --with-jpeg \
        --with-curl --with-zlib --with-mysqli --with-pgsql --with-pdo-mysql --with-pdo-pgsql \
        --enable-exif --enable-mbstring --with-openssl=/opt/ssl \
        --disable-session --disable-posix --disable-dom \
        --enable-memcache

RUN cd /opt/php-${PHP_VERSION} && make install-cli && \
    cp /root/php-bin/bin/php /opt/bin/php-bin

RUN env

RUN cd /opt && \
    curl -sS https://getcomposer.org/installer | /opt/bin/php && \
    /opt/bin/php -d memory_limit-1 composer.phar require aws/aws-sdk-php

RUN /opt/bin/php-bin -r "phpinfo();"