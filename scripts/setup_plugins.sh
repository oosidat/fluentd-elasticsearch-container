#!/bin/bash

if [ -f /.plugin_setup ]; then
	echo "Plugins already setup, /.plugin_setup file exists"
	exit 0
fi

echo "Initialized plugin setup"

FLUENT_CONF_FILE=/fluentd/etc/fluent.conf

DEFAULT_HOST=${ELASTICSEARCH_PORT_9200_TCP_ADDR:-localhost}
DEFAULT_PORT=${ELASTICSEARCH_PORT_9200_TCP_PORT:-9200}

ES_HOST=${ES_HOST:-$DEFAULT_HOST}
ES_PORT=${ES_PORT:-$DEFAULT_PORT}
ES_INDEX=${ES_INDEX:-fluentd}
ES_TYPE=${ES_TYPE:-fluentd}

MATCH_PATTERN=${MATCH_PATTERN:-docker.**}
# Clear the origin fluentd.conf
> $FLUENT_CONF_FILE
# Export new config
echo "
<source>
  @type  forward
  @id    input1
  port  24224
</source>
" >> $FLUENT_CONF_FILE

echo "
<filter *end>
  type parser
  format rails_log_to_time
  time_format %Y-%m-%dT%H:%M:%S.%N
  key_name log
  reserve_data yes
  hash_value_field @timestamp
</filter>" >> $FLUENT_CONF_FILE

echo "
<match **.*>
  @type copy
  <store>
    @type stdout
  </store>
  <store>
    @type elasticsearch
    host $ES_HOST
    port $ES_PORT
    logstash_format true
    index_name $ES_INDEX
    type_name $ES_TYPE
    time_key_format %Y-%m-%dT%H:%M:%S.%N
		include_tag_key true
  </store>
</match>" >> $FLUENT_CONF_FILE

echo "
<source>
  @type monitor_agent
  bind 0.0.0.0
  port 24220
</source>" >> $FLUENT_CONF_FILE

touch /.plugin_setup

echo "Finished setting up plugins on file $FLUENT_CONF_FILE"

curl -XPUT $ES_HOST:$ES_PORT/_template/template_logstash -d@elasticsearch-fluentd-template.json
