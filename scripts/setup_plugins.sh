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

AWS_ES=${AWS_ES:-false}

MATCH_PATTERN=${MATCH_PATTERN:-docker.**}

STORES=""

ELASTIC_SEARCH_STORE="
<store>
  type elasticsearch
  logstash_format true
  host $ES_HOST
  port $ES_PORT
  index_name $ES_INDEX
  type_name $ES_TYPE
  include_tag_key true
</store>"

AWS_ELASTIC_SEARCH_STORE="
<store>
  type aws-elasticsearch-service
  index_name $ES_INDEX
  flush_interval 5s
  logstash_format true
  buffer_type memory
  buffer_queue_limit 64
  buffer_chunk_limit 8m
  include_tag_key true
  <endpoint>
    region $AWS_REGION
    url $AWS_URL
    access_key_id $AWS_ACCESS_KEY_ID
    secret_access_key $AWS_SECRET_ACCESS_KEY
  </endpoint>
</store>"

if ! $AWS_ES; then
  STORES=$ELASTIC_SEARCH_STORE
else
  STORES=$AWS_ELASTIC_SEARCH_STORE
fi

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
  type copy
  $STORES
</match>" >> $FLUENT_CONF_FILE

echo "
<match **>
  type stdout
</match>" >> $FLUENT_CONF_FILE

touch /.plugin_setup

echo "Finished setting up plugins on file $FLUENT_CONF_FILE"
