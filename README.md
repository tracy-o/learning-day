# Belfrage
## What is Belfrage

__Belfrage__ is a routing and resiliency layer. It routes requests to upstream services after validating and transforming those requests, along with the responses from these services.  __Belfrage__ also provides many resilience features such as caching.

Belfrage is part of the WebCore stack, but it's also used in front of services that haven't migrated to WebCore yet.

## Documentation
The index for the documentation can be found [here](docs/index.md)

Some of the notable documents are:
 - [All about routing](docs/topics/routing/routing.md)
 - [Cascade](docs/topics/cascade.md)
 - [Personalisation](docs/topics/personalisation.md)
 - [Circuit-Breaker](docs/topics/circuit-breaker.md)
 - [Logging](docs/topics/debugging-testing/logging.md)

## Getting Belfrage running

### Installing Erlang and Elixir

#### Install asdf

The easiest way to install and use the right versions of Erlang/Elixir is to
use [`asdf`](https://asdf-vm.com/).

Install `asdf` as per instructions on its website, but if you use `oh-my-zsh`,
the easiest way is probably to install `asdf` as [`oh-my-zsh`
plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/asdf).

#### Install Erlang / Elixir

The versions of Erlang / Elixir that Belfrage uses are specified in
`.tool-versions` file. You can install them using that file by running this
command:

```
while IFS= read -r line; do asdf plugin add $(echo "$line" | awk '{print $1}'); done < .tool-versions && asdf install
```

It will add Erlang and Elixir `asdf` plugins and install the correct versions.

#### Install Hex and Dependencies

To install dependencies of Belfrage run:

```
mix local.hex && mix deps.get
```

### Run the app

Start the Belfrage application with: 

```
mix run --no-halt
```

When you see `Generated belfrage app` you are then able to visit http://localhost:7080/news

### Set your credentials to access Pres

*Note that these instruction may need to be updated*

Running locally, Belfrage will connect to the Test Lambda in the
webcore-sre-dev account. Unlike Prod and Test where Belfrage will assume a role
to refresh the credentials, local dev will simply use your local credentials
for the account. You can set these however you wish - if in doubt you can use
[cli-wormhole](https://github.com/bbc/cli-wormhole) and export them for
mozart_dev account number `134209033928`.

## See all the defined route matchers

To produce a markdown table with all the defined route matchers:

```
mix routes
```

Can also display routes for specific environments (test/live) only:

```
mix routes test
```

## Running Tests

To run unit tests:

```
mix test
```

To run the end to end integration suite in [./test/end_to_end/](./test/end_to_end/):

```
mix test_e2e
```

To run the automatically generated route matcher tests in [./test/routes/](./test/routes/):

```
mix routes_test
```

To run the automatically generated smoke tests on the example routes in the router [./test/smoke/](./test/smoke/):

```
mix smoke_test
```

### Run benchmark performance tests

```
mix benchmark
```

## Code style
We use the `mix format` to apply code style and formatting rules automatically. Our CI will fail if you do not run `mix format`

Want `mix format` to run automatically? Consider getting your IDE to do this on file changes, for example in VSCode the setting `"editor.formatOnSave": true` will format on every save or alternatively run `git config core.hooksPath .githooks` from this directory to add a pre-commit hook that will run `mix format` for you before allowing you to commit.

## Deployment pipeline
Belfrage is deployed using Jenkins and Cosmos. The [Belfrage job](https://ci.news.tools.bbc.co.uk/job/bbc/job/belfrage/) on Jenkins runs the tests for all branches that are pushed up to Github.

If the tests all pass then the [Multi Stack job](https://ci.news.tools.bbc.co.uk/job/belfrage-multi-stack/) is run in order to build the RPMs for all belfrage stacks. If the job is run for the master branch then a release is also created for the stacks.
