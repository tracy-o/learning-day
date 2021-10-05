# Temporary debug mode

The most basic work has been done to get some debug data. This will almost certainly be updated in the future, but it can have a bit of use now.

### Step 1: Make a Belfrage curl request
```
➜  ~ curl -I https://www.belfrage.test.api.bbc.co.uk/\?belfrage-cache-bust\&mode\=testData
HTTP/2 200
belfrage-cache-status: MISS
bid: www
brequestid: a7bfbe90658a4353988e8b25d82f261c
bsig: cache-bust.5158f58b-2fc9-4ffd-8f7b-001195363b9f
...
```
Then take a note of the `brequestid` value.

### Step 2: Go to the monitor, using the brequestid
```
https://monitor.web.test.api.bbci.co.uk/data/request/a7bfbe90658a4353988e8b25d82f261c
```
Then you'll see some log, and metric output, including:
- Access headers
- Timings such as `function.timing.service.lambda.invoke` for WebCore lambdas
- and other log and metric output