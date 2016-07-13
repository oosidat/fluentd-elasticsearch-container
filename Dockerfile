FROM fluent/fluentd:latest

MAINTAINER Osama Sidat

USER root
RUN apk add --update bash && rm -rf /var/cache/apk/*

ADD scripts/run.sh /run.sh
ADD plugins/json_in_string.rb /fluentd/plugins
ADD plugins/rails_log_to_time.rb /fluentd/plugins
ADD scripts/setup_plugins.sh /setup_plugins.sh
RUN chmod 755 /*.sh

WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH

RUN gem install fluent-plugin-parser
RUN gem install fluent-plugin-elasticsearch

EXPOSE 24224
EXPOSE 8888

ENTRYPOINT ["/run.sh"]
