# fluentd-elasticsearch-container

The container to send all containers' logs to an Elasticsearch container.

## Running

###### Simple run:

```
docker run -d --name some_cool_name oosidat/fluentd-elasticsearch-container
```

###### Run in vagrant box alongside other docker containers

* Ensure that there's an ElasticSearch container running at port 9200
* Run fluentd container:
```
docker run --net=host -d --name some_cool_name oosidat/fluentd-elasticsearch-container
```
* Ensure that other containers (which need to send logs) have their [log driver set to fluentd](https://docs.docker.com/engine/reference/logging/fluentd/)

###### Supported Environment Variables

*Pass using `-e` in `docker run` or using the `environment` key using `docker-compose`*

| Name | Description | Default |
| --- | --- | --- |
| ES_HOST | ElasticSearch host | localhost |
| ES_PORT | ElasticSearch port | 9200 |
| ES_INDEX | ElasticSearch index name | fluentd |
| ES_TYPE | ElasticSearch index type | fluentd |
| MATCH_PATTERN | fluentd matching pattern, used in `<filter>` & `<match>` | `docker.**` |
| FLUENTD_OPT | other options for running fluent | none (empty) |

##### Credits:
* [openfirmware/docker-fluentd-elasticsearch](https://github.com/openfirmware/docker-fluentd-elasticsearch)
* [Eric Fortin's custom fluent-plugin-parser plugin](https://github.com/docker/docker/issues/17830#issuecomment-176145149)
* [Fluentd docker image](https://github.com/fluent/fluentd-docker-image)
