### How to change log level on a running instance
You can change the logging level by changing the value of the 'logging level' cosmos dial, this may take up to one minute to change.

Here is the page for belfrage TEST:
https://cosmos.tools.bbc.co.uk/services/belfrage/test/dials

Here is the page for belfrage LIVE:
https://cosmos.tools.bbc.co.uk/services/belfrage/live/dials

If you want to check logs inside the instance, once inside
```
cat /var/log/component/app.log
```

### With built-in and helper functions in remote console
Belfrage system and process runtime data can also be gauged through Elixir's interactive shell (IEx), i.e. running `remote_console` on the instance. From the shell, various functions can be called, for example:
- [Process module convenience functions](https://hexdocs.pm/elixir/Process.html) such as `Process.info/1` that accepts a pid
- [Erlang Built-In Functions (BIFs)](https://erlang.org/doc/man/erlang.html), such as `:erlang.memory/0` and `:erlang.system_info/1`
- [Belfrage debug convenience functions](https://github.com/bbc/belfrage/blob/master/lib/belfrage/helpers/debug.ex) that returns various process-oriented information,m e.g. processes consuming most memory, longest message queue, number of processes per runtime function group