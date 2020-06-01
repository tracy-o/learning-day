# Belfrage

## What is Belfrage

__Belfrage__ is part of the WebCore stack, it takes care of transforming and validating HTTP requests to and from a rendering service like the WebCore presentation layer. Belfrage is generic enough to be used as an entry point for any BBC service with minimal effort.

Belfrage looks after the resiliency of the page, it monitors in real-time the status of the responses and can take actions in case of errors.

Belfrage is simple and fast, with a number of ancillary apps outside of the traffic flow to add additional features and functionality.

## Key features of Belfrage

### Layers

We use a simple architecture with clear separation of responsibilities for any layer.
Every layer knows how to communicate with the adjacent ones, but communication with further layers is discouraged. Only a subset of these layers will handle HTTP tasks, the rest of the layers will do business logic against the struct, an internal data structure representing the request/response cycle.

![alt text](./docs/layers.png)

[More details on the different layers are in the Layers document](./docs/layers.md)

### Struct

The struct is a data structure which will represent the state of the request at any moment. Internally it will be a hash map whose key will be progressively filled with data along the request path.

    struct = { request: {}, private: {}, response: {} }

At any time the system can log the struct giving the precise state of the current request (some values are removed for privacy).

It's the responsibility of the web interface to transform the struct into the final HTTP response.

![alt text](./docs/struct_lifecycle.png "Struct Lifecycle")

[Struct examples are in the Struct document](./docs/struct.md)

### Caching
Belfrage currently uses the "Erlang Term Storage" or ETS for in-memory cache. We have a small layer around the cache interface to only store successful responses for `GET` requests and non-personalised responses.

### Resiliency

#### Fallback
Fallback is the first resiliency feature to be added to Belfrage. It currently utilises the in-memory caching mechanism to serve stale, cached responses from origins if an origin returns an unsuccessful response. Currently, fallback responses do have an expiry and will not be stored indefinitely.

This feature is only available for non-personalised responses.

## Properties of Belfrage

* resilient
* performant
* handle failures
* more to come...

## Getting it running

### Install Elixir

Get Elixir 1.8 on your Mac.

```
brew install elixir
```

### Install Hex

Hex is a package manager for Elixir. You'll need it to install dependencies.

```
mix local.hex
```

### Install dependencies

```
mix deps.get
```

### Set your credentials

Running locally, Belfrage will connect to the Test Lambda in the webcore-sre-dev account. Unlike Prod and Test where Belfrage will assume a role to refresh the credentials, local dev will simply use your local credentials for the account. You can set these however you wish - if in doubt you can use [cli-wormhole](https://github.com/bbc/cli-wormhole) and export them for mozart_dev account number `134209033928`.

### Run the app

```
mix run --no-halt
```

The app runs on port 7080.

### Testing

To run unit tests use the standard `mix` command:
```
mix test
```

In addition to unit tests, Belfrage provides other test suites. These can be executed via dedicated mix tasks that run corresponding tests contained in specific subdirectories (see below) in [`./test`](./test/). When a particular suite is being run, the other test suites are excluded to provide faster test duration and clearer results summary. The mechanism is based on `mix test`'s [:test_pattern configuration](https://hexdocs.pm/mix/Mix.Tasks.Test.html#module-configuration) that uses file path extension (`_test.ex`) to select related tests - see https://github.com/bbc/belfrage/pull/415.

To run the end to end integration suite in [./test/end_to_end/](./test/end_to_end/):
```
mix test_e2e
```

To run the automatically generated route matcher tests in [./test/routes/](./test/routes/):
```
mix routes_test
```

To run the automatically generated smoke tests on the example routes in the router [./test/smoke/](./test/smoke/):
```elixir
  # test all example routes
  mix smoke_test

  # test a subset of routes
  mix smoke_test --only platform:Webcore
  mix smoke_test --only spec:Search
  mix smoke_test --only stack:bruce-belfrage

  # test a single route
  mix smoke_test --only route:/wales
  mix smoke_test --only route:/topics/:id

  # choose Cosmos environment with --bbc-env
  mix smoke_test --bbc-env live --only route:/topics/:id

  # for further information
  mix help smoke_test
```

### See all the defined route matchers

Will produce a markdown table with all the defined route matchers:
```
mix routes

```

It defaults to live but the environment can be passed:
```
mix routes test
```

### Run benchmark performance tests
```
mix benchmark
```

### Generate a self signed certificate
`mix x509.gen.selfsigned`


## Code style

We use the `mix format` to apply code style and formatting rules automatically. Our CI will fail if you do not run `mix format`

Want `mix format` to run automatically? Consider getting your IDE to do this on file changes, or alternatively run `git config core.hooksPath .githooks` from this directory to add a pre-commit hook that will run `mix format` for you before allowing you to commit.

Got an opinion on how `mix format` could do a better job? Edit `.formatter.exs`

## Deployment pipeline

Belfrage is deployed using Jenkins and Cosmos. The [Belfrage job](https://ci.news.tools.bbc.co.uk/job/bbc/job/belfrage/) on Jenkins runs the tests for all branches that are pushed up to Github.

If the tests all pass then the [Multi Stack job](https://ci.news.tools.bbc.co.uk/job/belfrage-multi-stack/) is run in order to build the RPMs for `belfrage` and `belfrage-preview`. If the job is run for the master branch then a release is also created for both stacks.
