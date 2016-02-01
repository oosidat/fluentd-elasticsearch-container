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

echo "
<filter $MATCH_PATTERN>
  type parser
  format json_in_string
  time_format %Y-%m-%dT%H:%M:%S.%L%Z
  key_name log
  hash_value_field log
</filter>" >> $FLUENT_CONF_FILE

echo "
<match $MATCH_PATTERN>
  type elasticsearch
  logstash_format true
  host $ES_HOST
  port $ES_PORT
  index_name $ES_INDEX
  type_name $ES_TYPE
  include_tag_key true
</match>" >> $FLUENT_CONF_FILE

touch /.plugin_setup

echo "Finished setting up plugins on file $FLUENT_CONF_FILE"
