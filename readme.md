# fluentd-elasticsearch-container

The container to send all containers' logs to an Elasticsearch container.

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

Credits:
* [openfirmware/docker-fluentd-elasticsearch](https://github.com/openfirmware/docker-fluentd-elasticsearch)
* [Eric Fortin's custom fluent-plugin-parser plugin](https://github.com/docker/docker/issues/17830#issuecomment-176145149)
