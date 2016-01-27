FROM fluent/fluentd:latest

MAINTAINER Osama Sidat

USER fluent
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.2.0/bin:$PATH

RUN gem install fluent-plugin-parser
RUN gem install fluent-plugin-elasticsearch

EXPOSE 24224
EXPOSE 8888

CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
