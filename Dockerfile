FROM danieldreier/wheezy-puppet-agent
MAINTAINER Daniel Dreier <daniel@deployto.me>

EXPOSE 9200
RUN apt-get -y update
RUN apt-get -y install command-not-found procps
RUN update-command-not-found
RUN touch /etc/puppet/hiera.yaml

ADD Puppetfile /etc/puppet/Puppetfile
RUN cd /etc/puppet; r10k puppetfile install
ADD . /etc/puppet/modules/site

RUN puppet apply /etc/puppet/modules/site/site.pp

# Install plugins
#RUN /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
#RUN /usr/share/elasticsearch/bin/plugin -url http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -install elasticsearch/kibana3

# Start Elasticsearch
#CMD /usr/share/elasticsearch/bin/elasticsearch
