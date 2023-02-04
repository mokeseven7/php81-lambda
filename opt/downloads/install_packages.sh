#!/bin/bash

#cd /opt
#tar -xzf /opt/downloads/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
#cd /opt/cmake-${CMAKE_VERSION}-linux-x86_64 && cp -r * /usr

cd /opt

tar -xzf /opt/downloads/memcache-${MEMCACHE_VERSION}.tgz

tar -xzf /opt/downloads/openssl-${OPENSSL_VERSION}.tar.gz

tar -xzf /opt/downloads/php-${PHP_VERSION}.tar.gz

tar -xzf /opt/downloads/libzip-${LIBZIP_VERSION}.tar.gz

tar -xzf /opt/downloads/bison-${BISON_VERSION}.tar.gz

tar -xzf /opt/downloads/freetype-${FREETYPE_VERSION}.tar.gz
