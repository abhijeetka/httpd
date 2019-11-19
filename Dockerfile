FROM centos:centos7

MAINTAINER new MAINTAINER

RUN yum -y update ; yum -y install httpd mod_ssl ;yum clean all

RUN sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
        /etc/httpd/conf/httpd.conf && \
    sed -i 's/Listen 80[[:space:]]*$/Listen 443/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/#ServerName www.example.com:80$/ServerName localhost/' /etc/httpd/conf/httpd.conf && \
    mkdir -p /etc/ssl/crt/ 

COPY crt/* /etc/ssl/crt/
RUN chmod -R 777 /etc/ssl/crt
COPY ssl.conf /etc/httpd/conf.d/ssl.conf
COPY index.html /var/www/html/

EXPOSE 80 443
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
