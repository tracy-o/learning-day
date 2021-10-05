# Caching

## Terminology

* Local cache: in memory cache runnng on the Node (EC2 instance)
* Distributed cache: 2nd tier fallback cache in S3

## Process

On a request the first action Belfrage takes is to look for cached content in the local cache. The cached content will be returned if found and it is `fresh`. If not, a request to the origin is then made.

If the origin returns a non 500 response then Belfrage will simply return that response. However, if the origin does return a 500 response then the fallback process kicks in. 408 responses are handled slightly differently in that they signify a timeout. In this case the fallback process is also triggered.

## Fallbacks

When Belfrage has received a 500 response from an origin it sets an internal flag called `fallback_on_error`. This means that Belfrage will then look to retrive the content from other locations. First we look for stale local content and then failing that we look in the distributed cache.

## Metrics

Belfrage records metrics for each type of cache result. You will be able to see these on the Grafana Dashboards.

It is worth being aware that due to the cascade a `cache.local.miss` metric is set for both the initial cache lookup and on the `fallback_on_error` request. This can mean that the metric is recorded twice for a request (once on the `miss` when requesting fresh content and once on the cascade request when fetching based on an origin 500).

## Cache flow

### Fetching fresh content

The following diagram shows the flow in Belfrage when requesting fresh cache content.

![belfrage-cache](img/belfrage-cache-fresh.svg)

[Diagram source](source/belfrage-cache-fresh.drawio)

### Caching in depth

The following diagram shows the detailed flow of cache content for fresh and stale content.

1. Check for "fresh" content in the local cache.
2. Check for "fresh" or "stale" content in the local or distributed cache (applicable when an origin has returned a 500 response).

![belfrage-cache](img/belfrage-cache.svg)

[Diagram source](source/belfrage-cache.drawio)
