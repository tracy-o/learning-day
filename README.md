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
 - [Logging](docs/topics/debugging-testing/logging.md)

## Getting Belfrage running

### Installing Erlang and Elixir
1. [Install the asdf package manager](https://asdf-vm.com/#/core-manage-asdf), the easiest way is through [Homebrew](https://brew.sh/) with `brew install asdf`.

However if you use `oh-my-zsh` as your prefered shell we recommend using the plugin approach to install asdf this can be done as follows:

Enable the plugin by adding it to your plugins definition in ~/.zshrc.
```
plugins=(asdf)
```
Install asdf by running the following:
```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
```

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

### See all the defined route matchers
To produce a markdown table with all the defined route matchers:
```
mix routes

```
Can also display routes for specific environments (test/live) only:
```
mix routes test
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