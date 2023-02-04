#Lambda base image Amazon linux
FROM public.ecr.aws/lambda/provided:latest as builder


COPY installation/update_os.sh /opt/installation/update_os.sh

RUN yum update -y && \
    yum install -y git gzip jq tar unzip vim wget zip

RUN /opt/installation/update_os.sh


ENV OPENSSL_VERSION 3.0.3
ENV BISON_VERSION 3.8.2
ENV CMAKE_VERSION 3.22.5
ENV LIBZIP_VERSION 1.8.0
ENV FREETYPE_VERSION 2.10.4
ENV PHP_VERSION 8.1.11

COPY opt/ /opt
RUN cd /opt/downloads && ./download_packages.sh
RUN cd /opt/downloads && ./install_packages.sh
RUN /opt/build/install_openssl.sh
RUN /opt/build/install_tools.sh

RUN yum install -y sqlite-devel

RUN cd /opt/php-${PHP_VERSION} && \
    ./buildconf --force && \
    ./configure --prefix=$HOME/php-8-bin/ --with-config-file-path=/opt/ini --with-openssl=/opt/ssl --with-curl --with-zlib

RUN make install       
