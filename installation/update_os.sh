#!/usr/bin/env bash

set -e

#######################  UPDATE OS

yum install -y autoconf bison diffutils freetype-devel gcc gcc-c++ glibc-devel glibc-devel.i686 gmp gmp-devel \
  help2man libcurl-devel libjpeg libjpeg-turbo-devel libpng libpng-devel libxml2-devel make mlocate openssl-devel \
  php-devel python36 re2c texi2html texinfo libmemcached-devel postgresql-devel oniguruma-devel



# Setup directory structure (similar to how it will be deployed in a lambda layer
mkdir -p /opt/{bin,src,ini,ssl,lib}/
mkdir -p /opt/ssl/certs


# Install Instructions: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html#cliv2-linux-install
# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
