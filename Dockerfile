FROM centos:centos7

MAINTAINER new MAINTAINER

RUN yum -y install epel-release ; yum -y update ; yum -y install httpd mod_ssl ;yum clean all

RUN sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
        /etc/httpd/conf/httpd.conf && \
    sed -i 's/Listen 80[[:space:]]*$/Listen 8080/' /etc/httpd/conf/httpd.conf && \
    mkdir -p /etc/ssl/certs/ && chmod 700 /etc/ssl/crt

COPY certs/* /etc/ssl/certs/
COPY ssl.conf /etc/httpd/conf.d/ssl.conf
COPY index.html /var/www/html/

EXPOSE 80 443
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]