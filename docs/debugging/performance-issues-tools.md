# Tools for Analysing Performance Issues

The Belfrage team needs to load test and unblock performance issues regularly to ensure Belfrage performs under high request rates. For example, we recently performed [load tests](https://github.com/bbc/belfrage/blob/master/docs/load-test-results/2020-05-05-cache-limit-reclaim.md) to verify the Tier-1 cache limit and reclaim mechanism in [#385](https://github.com/bbc/belfrage/pull/385). We also unblocked a performance bottleneck in sending metrics to Grafana in [#395](https://github.com/bbc/belfrage/pull/395).

Below is a list of tools that were used to analyse the performance of Belfrage [BEAM (Erlang) VM](https://blog.stenmans.org/theBeamBook/#_the_erlang_virtual_machine_beam) during the load tests, to pin down the root cause and identify the right solution which in [#395](https://github.com/bbc/belfrage/pull/395) case, was a simple one.

## observer_cli
Erlang provides a graphical tool called [`Observer`](http://erlang.org/doc/apps/observer/observer_ug.html) for runtime analysis of distributed nodes in an Erlang cluster. This is a de-facto tool in Elixir/Erlang development. However, [connecting to a Belfrage node on EC2 from local dev is not possible](https://jira.dev.bbc.co.uk/browse/RESFRAME-3500) due to accessibility issue of AWS private IPs from a local Erlang node. 

[`observer_cli`](https://github.com/zhongwencool/observer_cli) is a useful open-source alternative. It can be installed and invoked via Elixir interactive shell ([`IEx`](https://elixir-lang.org/getting-started/introduction.html#interactive-mode)) on a node (EC2 instance). 

Pre-requisites for running `observer_cli` on a Belfrage node:

- See: ["Playground tooling"](https://github.com/bbc/belfrage-playground#playground-tooling) for steps required to setup the pre-requisites: Erlang, Elixir and the Belfrage codebase
- [Add `observer_cli`](https://github.com/zhongwencool/observer_cli#installation) to Belfrage as dependency (in `mix.exs`)
 
Manually create and start a prod release (need environment variables setting, see `env.conf`), then attach to Belfrage via IEx console and start the tool. You may need to stop any Belfrage service that is running on the node:

```ex
$ MIX_ENV=prod mix distillery.release # build release
$ _build/prod/rel/belfrage/bin/belfrage start
$ _build/prod/rel/belfrage/bin/belfrage remote_console
```

```ex
iex> :observer_cli.start # starts the tool in the console
```

`observer_cli` enabled us to quickly pin the performance bottleneck in [#395](https://github.com/bbc/belfrage/pull/395) down to a particular metrics process (`ExMetrics.Statsd.Worker`) which had a huge and growing message queue during load tests. Message queue and [Reduction count](https://medium.com/@gabkolawole/reductions-and-cpu-usage-with-elixir-erlang-vm-5e47eaae6448) are some of the key Erlang process metrics.

<img width="979" alt="observer_cli_output1" src="https://user-images.githubusercontent.com/104361/83675995-e1026580-a5d1-11ea-8b1a-75231249f1a7.png">

The tool provides other essential Erlang VM data including as CPU usage among CPU cores. For example, it has a Network section that lists all active network ports with real-time traffics usage such as I/O (bandwidth), message counts (`recv_cnt` and `send_cnt`). 

<img width="980" alt="Screenshot 2020-06-04 at 09 27 48" src="https://user-images.githubusercontent.com/104361/83733617-af2ae680-a645-11ea-92dc-b651ae61884e.png">

The `Port` analytics helped us to identify the root cause: metric traffics was being routed through a single port. This bottleneck was simply removed by distributing the metrics data among a pool of worker processes and ports. The tool also used to verify the solution as it provided a mean to visualise real-time metric traffics through multiple ports.

## etop
Belfrage Tier-1 cache is in-memory and stored in [ETS](https://erlang.org/doc/man/ets.html). In [#385](https://github.com/bbc/belfrage/pull/385), `observer_cli` provided ETS analytics for gauging the caching behaviour and verifying cache reclaim mechanism during load tests.

The work also made use of [`etop`](http://erlang.org/doc/man/etop.html) - **Erlang Top** from the `Observer` app distribution which provides `top`-like data on Erlang processes. Unlike the open-source `observer_cli` that needed to be added as dependency to Belfrage, `etop` is part of Erlang and readily available, e.g. `:etop.start` in IEx.

<img width="633" alt="Screenshot 2020-06-03 at 20 36 39" src="https://user-images.githubusercontent.com/104361/83681218-009d8c00-a5da-11ea-9150-950065abd4e3.png">

## msacc
[`msacc`](https://erlang.org/doc/man/msacc.html) - **microstate accounting** from [Erlang runtime tools distribution](https://erlang.org/doc/man/runtime_tools_app.html) which is a built-in part of Belfrage production releases. 

It was used during a 30-minute load test in [#385](https://github.com/bbc/belfrage/pull/385) to measure the time spent by Erlang VM on various system tasks, i.e. "states" such as `scheduler`, `check_io`, `gc` etc. For further details, see [Erlang system states](https://erlang.org/doc/man/erlang.html#statistics_microstate_accounting). 

`msacc` provides fine-grained statistics that offers enhanced insight into system states such as `emulator`, `gc` and `other`. To enable these additional system states accounting, Erlang needed to be compiled and installed with additional configuration, for example on Belfrage EC2 instance that uses `asdf`, the configuration can be set via the `KERL_CONFIGURE_OPTIONS` environment variable: 

```
$ export KERL_CONFIGURE_OPTIONS="--with-microstate-accounting=extra"
$ asdf install erlang  22.3.3
```

A one-minute microstate accounting statistic sample was generated in [#385](https://github.com/bbc/belfrage/pull/385) during the 30-minute load test through IEx:

```ex
iex(belfrage@10.114.166.240)1> :msacc.start 60000
iex(belfrage@10.114.166.240)2> :msacc.print
```

The resultant data indicated that Belfrage VM spent the majority of time in processing requests. The work load was spread evenly across all 8 scheduler threads (8-core CPU) suggesting efficient CPU usage. 

See: the [one-minute microstate stats](https://github.com/bbc/belfrage/blob/master/docs/load-test-results/data/2020-05-05/30min_50percent_repeater_100kb_msacc_threads.csv).

## Other tools
- Other tools from the [Observer application distribution](http://erlang.org/doc/man/Observer_app.html)
- Other [Erlang Runtime tools](https://erlang.org/doc/man/runtime_tools_app.html)
