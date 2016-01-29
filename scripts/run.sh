#!/bin/bash

if [ ! -f /.plugin_setup ]; then
  /setup_plugins.sh
fi

fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT
