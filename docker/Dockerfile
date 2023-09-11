FROM httpd:latest

RUN apt update

COPY ./docker/folder /usr/local/apache2/htdocs/

COPY ./docker/index.html /usr/local/apache2/htdocs/

COPY ./docker/httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 443