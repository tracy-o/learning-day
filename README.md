# Belfrage

## What is Belfrage
__Belfrage__ is part of the WebCore stack, it takes care of transforming and validating HTTP requests to and from a rendering service like the WebCore presentation layer. Belfrage is generic enough to be used as an entry point for any BBC service with minimal effort.

Belfrage looks after the resiliency of the page, it monitors in real-time the status of the responses and can take actions in case of errors.

Belfrage is simple and fast, with a number of ancillary apps outside of the traffic flow to add additional features and functionality.

## Documentation
The index for the documentation can be found [here](docs/index.md)

Some of the notable documents are:
 - [All about routing](docs/topics/routing/routing.md)
 - [Cascade](docs/topics/cascade.md)
 - [Personalisation](docs/topics/personalisation.md)
 - [Circuit-Breaker](docs/topics/circuit-breaker.md)

## Getting Belfrage running

### Installing Erlang and Elixir

1. [Install the asdf package manager](https://asdf-vm.com/#/core-manage-asdf), the easiest way is through [Homebrew](https://brew.sh/) with `brew install asdf`.

2. Use asdf to install Erlang and Elixir
**Note**: Please read this [guide](https://github.com/asdf-vm/asdf-erlang#before-asdf-install), to establish the prerequisites for a successful installation of Erlang for your operating system.  

The versions of Erlang/Elixir that are supposed to be used are specified in the [`.tool-versions`](.tool-versions) file.

You can read through the documentation on asdf on how to install Erlang and Elixir but here is a tl;dr:

```
asdf plugin add erlang
asdf install erlang {VERSION}
asdf global erlang {VERSION}

asdf plugin add elixir
asdf install elixir {VERSION}
asdf global elixir {VERSION}
```
(The erlang install can take a little while)

### Installing Hex and Dependencies

3. [Hex](https://hex.pm/) is a package manager for Elixir. You'll need it to install dependencies.
To install it, just run:

```
mix local.hex
```
4. Then install all required dependencies: 

```
mix deps.get
```

### Set your credentials and certificates

5. Running locally, Belfrage will connect to the Test Lambda in the webcore-sre-dev account. Unlike Prod and Test where Belfrage will assume a role to refresh the credentials, local dev will simply use your local credentials for the account. You can set these however you wish - if in doubt you can use [cli-wormhole](https://github.com/bbc/cli-wormhole) and export them for mozart_dev account number `134209033928`.

6. Generate a self signed certificate with the command: 

```
mix x509.gen.selfsigned
```

### Run the app
7. Start the Belfrage application with: 
```
mix run --no-halt
```
When you see `Generated belfrage app` you are then able to visit http://localhost:7080/news

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

## Code style

We use the `mix format` to apply code style and formatting rules automatically. Our CI will fail if you do not run `mix format`

Want `mix format` to run automatically? Consider getting your IDE to do this on file changes, or alternatively run `git config core.hooksPath .githooks` from this directory to add a pre-commit hook that will run `mix format` for you before allowing you to commit.

Got an opinion on how `mix format` could do a better job? Edit `.formatter.exs`

## Deployment pipeline

Belfrage is deployed using Jenkins and Cosmos. The [Belfrage job](https://ci.news.tools.bbc.co.uk/job/bbc/job/belfrage/) on Jenkins runs the tests for all branches that are pushed up to Github.

If the tests all pass then the [Multi Stack job](https://ci.news.tools.bbc.co.uk/job/belfrage-multi-stack/) is run in order to build the RPMs for `belfrage` and `belfrage-preview`. If the job is run for the master branch then a release is also created for both stacks.

## Logging

There are currently two logging solutions in place for Belfrage, each serving different purposes. We have the App logs that are surfaced in Sumologic and we also have more granular logs that are sent to CloudWatch.

### App logs

The Belfrage App logs are a critical part of understanding the behaviour and resilience of the application. These are fundamental and should always be operational. The default level is `error` and so all errors are recorded. See below for details on the Dial that can raise this value.

The configuration is set so that each instance stores its logs on the filesystem. The `td_agent` service then offloads these logs to an S3 bucket for storage. We then have a collector in [Sumologic](https://service.eu.sumologic.com/ui/) request all the logs for each Stack so that they can be easily viewed and queried.

In the first instance we should look to the logs in Sumologic when there is an issue or for keeping an eye on the status of the platform.

To check the latest logs, first go to Sumologic here https://service.eu.sumologic.com/ui/. You will need an account to access this. You can also view the logs directly in the S3 bucket if you need to but it is more cumbersome to do so.

If there are any issues using Sumologic then you may wish to check the logs directly on the instance itself. You can do this via the Instances section on Cosmos where you can request access through the Bastions. Note, whilst this will give you a realtime view of the logs there are a few things to be aware of.

* There are multiple stacks
* There are multiple instances per stack
* You are accessing a live running server so caution is required

#### Logging Level Dial

The Belfrage App logs can also be adjusted via the use of a Dial. This allows us to elevate the level from `error`. This should be done sparingly as the debug logs from Monitor can be used. If the dial is changed make sure to change it back as soon as you can.

The Dial can be used if there are issues with Monitor or you need to clarify events in order to gain more information. In the first instance use the debug logs in Cloudwatch.

Increasing the log level in Belfrage using the dial will means much more noise in the logs and make it harder to spot actual errors. It would mean an increase in costs so we need to be mindful of how long they are increased for.

### Cloudwatch logs

Belfrage also stores logs that are then sent to Cloudwatch. These are logged at a higher level, currently set to the level of `warn`, so provide extra information when debugging an issue. They are always available for the specified retention period and not currently intended as a replacement to the app logs.

The logs are stored in `/var/log/component/cloudwatch.log` and offloaded to the Cloudwatch group named after the stack `/aws/ec2/[stack-name]`. The best way to query the logs in CloudWatch is to use [Log Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html).
