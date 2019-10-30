FROM ubuntu
MAINTAINER Andrew Morrison
RUN apt update
RUN apt-get -y install default-jre
RUN apt-get -y install git
RUN apt-get -y install curl
ADD saxon /tmp/bodleian-mmm/saxon
ADD x3ml /tmp/bodleian-mmm/x3ml
ADD xquery /tmp/bodleian-mmm/xquery
ADD scripts /tmp/bodleian-mmm/scripts
ADD settings.conf /tmp/bodleian-mmm/settings.conf
WORKDIR /tmp/bodleian-mmm
ENTRYPOINT ["/bin/bash", "-c", "scripts/main.sh"]