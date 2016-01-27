# fluentd-elasticsearch-container

The container to send all containers' logs to an Elasticsearch container.

To run:

```
docker run -d -v /var/lib/docker/containers:/var/lib/docker/containers --name some_cool_name oosidat/fluentd-elasticsearch-container
```
