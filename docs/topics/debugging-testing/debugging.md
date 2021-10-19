## How to change log level on a running instance
You can change the logging level by changing the value of the 'logging level' cosmos dial, this may take up to one minute to change.

Here is the page for belfrage TEST:
https://cosmos.tools.bbc.co.uk/services/belfrage/test/dials

Here is the page for belfrage LIVE:
https://cosmos.tools.bbc.co.uk/services/belfrage/live/dials

If you want to check logs inside the instance, once inside
```
cat /var/log/component/app.log
```

## With built-in and helper functions in remote console
Belfrage system and process runtime data can also be gauged through Elixir's interactive shell (IEx), i.e. running `remote_console` on the instance. From the shell, various functions can be called, for example:
- [Process module convenience functions](https://hexdocs.pm/elixir/Process.html) such as `Process.info/1` that accepts a pid
- [Erlang Built-In Functions (BIFs)](https://erlang.org/doc/man/erlang.html), such as `:erlang.memory/0` and `:erlang.system_info/1`
- [Belfrage debug convenience functions](https://github.com/bbc/belfrage/blob/master/lib/belfrage/helpers/debug.ex) that returns various process-oriented information,m e.g. processes consuming most memory, longest message queue, number of processes per runtime function group

## Debug mode 

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