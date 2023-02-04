#!/usr/bin/env bash

#OPENSSL_VERSION=1.1.1

#######################  INSTALL OPENSSL  (Note current version: 1.0.2r)
# Compile OpenSSL v1.0.1 from source, as Amazon Linux uses a newer version than the Lambda Execution Environment, which
# would otherwise produce an incompatible binary.

cd /opt

case $OPENSSL_VERSION in
1.1.1h)
# Default directory is /usr/local/ssl
    cd openssl-${OPENSSL_VERSION} && ./config && ./Configure linux-x86
#    cd openssl-${OPENSSL_VERSION} && ./config && ./Configure --prefix=/opt/ssl  --openssldir=/opt/ssl linux-x86
    make && make install
;;
1.1.1d)
# Default directory is /usr/local/ssl
    cd openssl-${OPENSSL_VERSION} && ./config && ./Configure linux-x86
#    cd openssl-${OPENSSL_VERSION} && ./config && ./Configure --prefix=/opt/ssl  --openssldir=/opt/ssl linux-x86
    make && make install
;;
1.0.2t)
#    curl -sL http://www.openssl.org/source/openssl-1.0.2t.tar.gz | tar -xvz
    cd openssl-${OPENSSL_VERSION} && ./config --openssldir=/opt/ssl && make && make install
;;
esac

mkdir -p /opt/ssl/certs
cd /opt/ssl/certs && wget http://curl.haxx.se/ca/cacert.pem
cp /opt/ssl/certs/cacert.pem /opt/ssl/cert.pem
