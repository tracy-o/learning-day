# Caching

## Design

Belfrage can offer an optional caching and resiliency layer. Routes requiring these features can rely on faster response times, less load on the origin and the peace of mind of a fallback content in case of temporary faults.

Personalised pages will not be able to use the cache feature. The fallback option will still be available.

## Process

On a request the first action Belfrage takes is to look for a cached content in the local cache. The cached content will be returned if found and it is `fresh`. If not, a request to the origin is then made with a metric of `cache.local.miss` being set.

If the origin returns a response then great, Belfrage returns that response.

In the case of an error Belfrage will set `fallback_on_error` which essentially means that a cascade of requesting stale from local, and then from the distributed cache takes place.

Note: a `cache.local.miss` metric is also set on the `fallback_on_error` cascade request when fresh or stale content is not found.

## Fallbacks

When an error is returned, and the route configuration indicates that an attempt to serve fallback is possible, Belfrage will try to fetch a fallback from the local (in-memory) cache.

In case of MISS, it will then try to fetch this page from the distributed (S3 or 2nd tier) cache. In case of success, the user will see a successful page.

The Fallback TTL is currently configured as 6h.

## Terminology

* Local cache: in memory cache runnng on the Node (EC2 instance)
* Distributed cache: 2nd tier fallback cache in S3

## Caching in depth

1. Check for "fresh" content in the local cache.
2. Check for "fresh" or "stale" content in the local or distributed caches if an error was returned.

![belfrage-cache](img/belfrage-cache.svg)

