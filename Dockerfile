FROM danieldreier/wheezy-puppet-agent
MAINTAINER Daniel Dreier <daniel@deployto.me>

EXPOSE 9200
RUN apt-get -y update
RUN apt-get -y install command-not-found procps vim
RUN update-command-not-found

ADD Puppetfile /etc/puppet/Puppetfile
RUN cd /etc/puppet; r10k puppetfile install
ADD . /etc/puppet/modules/site

RUN puppet apply /etc/puppet/modules/site/site.pp

# Install plugins
#RUN /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
#RUN /usr/share/elasticsearch/bin/plugin -url http://download.elasticsearch.org/kibana/kibana/kibana-latest.zip -install elasticsearch/kibana3

# Start Elasticsearch
#CMD /usr/share/elasticsearch/bin/elasticsearch

RUN wget https://github.com/coreos/etcd/releases/download/v0.3.0/etcd-v0.3.0-linux-amd64.tar.gz
RUN tar -xzvf etcd-v0.3.0-linux-amd64.tar.gz
RUN cp etcd-v0.3.0-linux-amd64/etc* /usr/local/bin
RUN cd /usr/lib/ruby/vendor_ruby/hiera/backend; wget https://raw.githubusercontent.com/garethr/hiera-etcd/master/lib/hiera/backend/etcd_backend.rb
ADD hiera.yaml /etc/hiera.yaml
RUN ln -s /etc/hiera.yaml /etc/puppet/hiera.yaml
RUN gem install etcd

RUN wget -O confd_0.3.0_linux_amd64.tar.gz https://github.com/kelseyhightower/confd/releases/download/v0.3.0/confd_0.3.0_linux_amd64.tar.gz
RUN tar -zxvf confd_0.3.0_linux_amd64.tar.gz
RUN mv confd /usr/local/bin/confd
RUN mkdir -p /etc/confd/{conf.d,templates}
ADD myconfig.toml /etc/confd/conf.d/myconfig.toml
ADD myconfig.conf.tmpl /etc/confd/templates/myconfig.conf.tmpl
ADD confd.toml /etc/confd/confd.toml

#CMD confd -verbose -debug=true
