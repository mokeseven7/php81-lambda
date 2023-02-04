#!/usr/bin/env bash

#export OPENSSL_ROOT_DIR=/opt/ssl
#export OPENSSL_INCLUDE_DIR=/opt/ssl/include
#export OPENSSL_LIBRARIES=/opt/ssl/lib
#
##install cmake from source
#mkdir /libzip && cd /libzip && wget https://cmake.org/files/v3.16/cmake-3.16.0.tar.gz && \
#    tar zxf cmake-3.16.0.tar.gz && \
#    cd cmake-3.16.0 && \
#    ./bootstrap && \
#    make && \
#    make install


yum install -y bzip2 bzip2-devel

# Build libzip from source, as the yum repos have an older version: 0.10.1, requires >= 0.11
cd /opt/libzip-${LIBZIP_VERSION} && \
    mkdir build && \
    cd build && \
    CFLAGS=-DBUILD_SHARED_LIBS=OFF cmake .. && \
    make -j -l 2.5 && \
    make -j -l 2.5  test && \
    make -j -l 2.5  install
cp /usr/local/lib64/libzip* /opt/lib/


cd /opt/bison-3.4 && ./configure && make install

cd /opt/freetype-${FREETYPE_VERSION}
./configure
make
make install