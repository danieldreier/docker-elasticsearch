FROM debian:wheezy
MAINTAINER Daniel Dreier <daniel@deployto.me>

# add elasticsearch apt repository
ADD GPG-KEY-elasticsearch /tmp/GPG-KEY-elasticsearch
RUN apt-key add /tmp/GPG-KEY-elasticsearch
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/1.1/debian stable main' >> /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install elasticsearch
RUN apt-get install -y --force-yes openjdk-7-jre-headless wget

# Install plugins
RUN /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
RUN /usr/share/elasticsearch/bin/plugin -url http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -install elasticsearch/kibana3

# Expose port 9200
EXPOSE 9200

# Start Elasticsearch
CMD /usr/share/elasticsearch/bin/elasticsearch
