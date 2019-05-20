# Struct

Current struct example
```
{
   "request": {
        "request_id": "d5a2d7676858b9f86d725d96585373d3",
        "environment": "live",
        "request_type": "GET",
        "path": "/news/story/123",
        "country": "gb",
        "edition": "domestic",
        "hashed_user_id": "123abc",
        "date_time_utc": "2019-04-24 10:37:26 UTC",
        "user_token": "abc123xyz"
    },
    "private": {
        "matcher_id": "NewsStory",
        "route": "on",
        "circuit_breaker": "off",
        "try_fallback_on_error": true,
        "timeout": 1000,
        "req_pipeline": ["story_validator", "user_validator"],
        "resp_pipeline": ["resp_validator", "debug"]
    },
    "response": {
        "source": "presentation",
        "http_status": 200,
        "headers": {
            "cache_control": "public, max-age=30",
            "vary": "edition,user_token",
            "set-cookie": "foo",
            "Content-Type": "text/html; charset=utf-8",
            "Transfer-Encoding": "gzip",
            "Content-Security-Policy": "default-src https"
        },
        "body": "H4sIAAAAAAAA/7PJMLTLSM3JyVcIzy/KSbHRB/IBnHcpQRQAAAA="
    }
}
```

Proposed Payload Example
```
{
   "request": {
        "request_id": "d5a2d7676858b9f86d725d96585373d3",
        "environment": "live",
        "request_type": "GET",
        "path": "/news/story/123",
        "country": "gb",
        "hashed_user_id": "123abc",
        "date_time_utc": "2019-04-24 10:37:26 UTC"
    },
    "experiments": {},
    "config": {
        "election_mode": "campaign",
        "front_page_video": "on"
    },
    "version": 1
}
```
