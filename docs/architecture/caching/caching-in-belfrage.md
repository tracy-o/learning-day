
# Table of Contents

1.  [Design](#org04522d0)
2.  [Fallback Mechanism](#orga4b8508)
3.  [Caching tiers](#org41b3228)
    1.  [Tier 1 - Local Cache](#org14d93d9)
    2.  [Tier 2 - Distributed cache](#orgeb982e3)
4.  [Modes](#orgb52fd76)
    1.  [Active Mode](#orgc93f17b)
    2.  [Passive Mode](#org021da99)
5.  [Caching & Circuit Breaker](#org1fad263)
6.  [Personalised content](#org9233a53)


<a id="org04522d0"></a>

# Design

Belfrage can offer an optional caching and resiliency layer. Routes requiring these features can rely on faster response times, less load on the origin and the peace of mind of a fallback content in case of temporary faults.

Personalised pages will not be able to use the cache feature. The fallback option will still be available. It's still early stage for this, but the plan is to serve the un-personalised fallback version of the page when the errors reach the circuit breaker threshold.


<a id="orga4b8508"></a>

# Fallback Mechanism

When an error is returned, and the route configuration indicates that an attempt to serve fallback is possible, Belfrage will try to fetch a fallback copy from the in-memory cache. 

In case of MISS, it will then try to fetch this page from the distributed cache. In case of success, the user will see a successful page. After a certain threshold of fallbacks alarm will be raised so that the Belfrage and the SRE team can take corrective actions.

Fallback TTL is currently configured as 6h.

![Fallback Mechanism](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_fallback_mechanism.png "Fallback Mechanism")

<a id="org41b3228"></a>

# Caching tiers

Belfrage will provide two cascading caching layers:


<a id="org14d93d9"></a>

## Tier 1 - Local Cache

A per-node in-memory LRU cache with no network involved and almost no latency. Currently, every Belfrage node can cache around 12Gb of content.
RESFRAME-2881 plans work to pre-warm the cache for new nodes added to the pool.

NOTE: future iterations could implement smarter ways to determine which content has more chances to get a hit or requires continuous presence in the in-memory cache.


<a id="orgeb982e3"></a>

## Tier 2 - Distributed cache

A slower and longer-term cache used for fallback reasons. If the first tier misses a fallback page, Belfrage will try to fetch it form this second tier before returning a 500.

NOTE: TIER 2 work hasn't started yet. The current plan is to use S3 as cache storage.
S3 Advantages:

-   S3 will not pose any limit in terms of number of stored items,
-   S3  offers a self-deleting mechanism once the max life of the page is reached
-   S3 offer multi-region (only 2 currently) bucket sync
-   S3 performance is less of a problem because of the TIER 1 layer.


<a id="orgb52fd76"></a>

# Modes

Cache in Belfrage can be set per-route in active and passive mode.


<a id="orgc93f17b"></a>

## Active Mode

This mode will allow serving cached content for a specified TTL. During this fraction of time, cached content will be served if available. Once the content gets stale, a new request to the origin will be made which will ultimately update the cache. Even if stale pages will be kept in the cache and used as a fallback mechanism in case of faults. The max fallback TTL is currently 6h.

![Active Mode](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_active_cache_hit.png "Active Mode HIT")
![Active Mode](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_active_cache_miss.png "Active Mode MISS")

<a id="org021da99"></a>

## Passive Mode

A route configured in passive mode will not serve any cached content but will still store successful non-personalised responses as a fallback.

![Passive Mode](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_passive_cache_200.png "Passive Mode 200")
![Passive Mode](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_passive_cache_500.png "Passive Mode 500")

<a id="org1fad263"></a>

# Caching & Circuit Breaker

The Circuit Breaker relies massively on the caching layer. Essentially it monitors routes error responses, and if a threshold is reached, it simulates an origin error to stop attempting to fetch content from the origin temporarily. In the meantime, the simulated failure triggers the fallback mechanism.

Error thresholds are configurable per-route.

The retry mechanism will improve in time; the first iteration is pretty simple and just stops calling a faulty endpoint for a given amount of time. Next iterations will introduce progressive reintroduction of faulty services and retry policies.

NOTE: while the circuit breaker is active and continuously monitoring routes response statuses it still doesn't trigger. We plan to enable it in Q3 2019.


<a id="org9233a53"></a>

# Personalised content

This will require additional work, expected to start in Q4 2019

