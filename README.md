# Ingress
[![Build Status](https://travis-ci.org/bbc/ingress.svg?branch=master)](https://travis-ci.org/bbc/ingress)

## What is Ingress

__Ingress__ is the HTTP interface of the Web Core stack as it takes care of transforming and validating HTTP requests to and from the presentation layer.

Ingress looks after the resiliency of the page, it monitors in real-time the status of the responses and can take actions in case of problems.

Ingress is simple and fast, with a number of ancillary apps outside of the traffic flow to add additional features and functionality.

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

### Run the app

```
mix run --no-halt
```

The app runs on port 7080.

### Run benchmark performance tests
```
mix benchmark
```

## Key features of Ingress

### Layers

Our aim is to use a simple architecture with clear separation of responsibilities for any layer.
Every layer should know how to communicate with the adjacent ones, but communication with further layers is discouraged. Only a subset of these layers will handle HTTP tasks, the rest of the layers will do business logic against the struct, an internal data structure representing the request/response cycle.

![alt text](./docs/layers.png)

[More details on the different layers are in the Layers document](./docs/layers.md)

### Struct

The struct is a data structure which will represent the state of the request at any moment. Internally it will be a hash map whose key will be progressively filled with data along the request path.

    struct = { request: {}, private: {}, response: {} }

At any time the system can log the struct giving the precise state of the current request (some values are removed for privacy).

It's the responsibility of the web interface to transform the struct into the final HTTP response.

![alt text](./docs/struct_lifecycle.png "Struct Lifecycle")

[Struct examples are in the Struct document](./docs/struct.md)

## Properties of Ingress

* resilient
* performant
* handle failures
* more to come...
