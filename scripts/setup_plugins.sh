#!/bin/bash

if [ -f /.plugin_setup ]; then
	exit 0
fi

echo "Setting up plugins"

FLUENT_CONF_FILE=/fluentd/etc/fluent.conf

DEFAULT_HOST=${ELASTICSEARCH_PORT_9200_TCP_ADDR:-localhost}
DEFAULT_PORT=${ELASTICSEARCH_PORT_9200_TCP_PORT:-9200}

ES_HOST=${ES_HOST:-$DEFAULT_HOST}
ES_PORT=${ES_PORT:-$DEFAULT_PORT}
ES_INDEX=${ES_INDEX:-fluentd}
ES_TYPE=${ES_TYPE:-fluentd}

PATTERN=${MATCH_PATTERN:-docker.**}

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

echo "Setting up plugins on file $FLUENT_CONF_FILE"
