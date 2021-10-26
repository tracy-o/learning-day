Belfrage dials architecture and how-to.

## Architecture
Belfrage relies on Cosmos dials to provide near real-time controls for caching TTL, logging verbosity (log-level) and circuit breaker that throttles requests to malfunctioning origins. Dial values are imported into Belfrage runtime through supervised [GenServer](https://hexdocs.pm/elixir/GenServer.html) architecture (below) which is based on two key elements: supervised GenServer dial processes and event handling.

![https://github.com/bbc/belfrage/blob/master/docs/img/belfrage_dials_architecture.png]
### Supervised GenServer dial processes
Each dial has a runtime state that is based on a discrete value in the JSON file (`dials.json`) serialised by Cosmos dials service. A fault-tolerant architecture necessitates decoupling of dials values in the file from their runtime usage because the JSON file is network-dependent and liable to corruption. GenServer provides a safe way to extract, transform and store a dial state in-memory efficiently. Dial read performance is also crucial, for example the TTL (multiplier) dial is read by [`CacheDirective`](https://github.com/bbc/belfrage/blob/1c6feb2d6d5d6501e4b90e2004e76357b2bef2f0/lib/belfrage/response_transformers/cache_directive.ex#L17) for every request.

A dial in Belfrage is an implementation of [`Dial` behaviour](https://github.com/bbc/belfrage/blob/master/lib/belfrage/dial.ex) which in turn implements `GenServer`. This makes Belfrage dial a GenServer process. `Dial` consists both the following callbacks and default implementation in the mould of Template Method (*cf.* abstract class):

Callbacks (interface functions):

- `transform/1`: transform state from JSON string into Elixir data types, e.g. "default" -> integer TTL multiplier value. The transformation only happens on state change event.
- `on_change/1`: optional for any post dial change actions such as changing Logger level in the log dial.

Default callbacks implementation in `Dial`:

- `state/1`: read dial state as Elixir data type, e.g. `true` (boolean) instead of `"true"` without type conversion (improves read performance).
- `dials_changed` event handling: `GenServer` callback override that triggers dial state transformation and actions, i.e. the `transforms`, `on_change` callbacks.

`DialsSupervisor` has a dual role: [Supervisor](https://hexdocs.pm/elixir/Supervisor.html) and event manager. It provides
fault-tolerance and responsible for handling the lifecycle of dials while ensuring high-availability such as initialise dial with usable default states. `DialConfig` deals with the concerns related to dial modules and defaults configuration such that new dials can be added to Belfrage without further changes in other parts of the architecture.
 
### Event handling
Dials state updates are facilitated through event-handling:

- `Poller` is a GenServer process that read and parse Cosmos dials JSON at regular interval. It stores the parsed JSON in-memory, notifies `DialsSupervisor` of dials changed events.
- `DialsSupervisor` acts as [event manager](http://blog.plataformatec.com.br/2016/11/replacing-genevent-by-a-supervisor-genserver/). It keeps a list of dials as event handlers, sends JSON data and propagates "dials_changed" event on all dials.

## Fault tolerance
The reliability of Belfrage dials is crucial. For example, the TTL dial state is called upon in every Belfrage request. Any uncaught exception arising from the TTL dial state call can be detrimental to Belfrage operation.

Various tests have been conducted to gauge Belfrage fault-tolerance in unexpected scenarios due to Cosmos dial data corruption:

- see ["Dials fault tolerance" report](https://github.com/bbc/belfrage/blob/master/docs/load-test-results/2020-07-06-dials-fault-tolerance.md)

These are the pending tests to further improve resiliency of Belfrage dials:

- [dials behaviour post-restart](https://jira.dev.bbc.co.uk/browse/RESFRAME-3663)
- [GenServer/Supervisor: multiple crashes](https://jira.dev.bbc.co.uk/browse/RESFRAME-3685)

## How to create a dial

1. Create and add the dial in [cosmos/dials.json](https://github.com/bbc/belfrage/blob/master/cosmos/dials.json) according to [Cosmos guideline](https://confluence.dev.bbc.co.uk/display/platform/Developing+with+Dials#DevelopingwithDials-3:WriteaDialSchema).


2. Create a dial module (and tests) in Belfrage by implementing the following functions in `Dial` behaviour:
    - `transform/1`: map all string values of the dial into a Belfrage data type, for example:
    
      ```
      def transform("true"), do: true
      def transform("false"), do: false
      ```
    - `on_change/1` (optional): for any explicit action after dial state change. 
    
    An example is [changing logging level dial](https://github.com/bbc/belfrage/blob/1c6feb2d6d5d6501e4b90e2004e76357b2bef2f0/lib/belfrage/dials/logging_level.ex#L14),
    and [related tests](https://github.com/bbc/belfrage/blob/master/test/belfrage/dials/logging_level_test.exs)

3. Add the default state for the dial to the list in [test/support/resources/dials.json](https://github.com/bbc/belfrage/blob/5dc76af57732bc77a59d842cf805822d596839cd/test/support/resources/dials.json)
For example: `"logging_level":"debug"`


4. Add the dial mapping in Belfrage `dial_handler` configuration within confix.exs:

  ```
    dial_handlers: %{
      "circuit_breaker" => Belfrage.Dials.CircuitBreaker,
      ...
      "new_dial" => Belfrage.Dials.NewDial
    }
  ```
  
5. New dial is available to read in Belfrage via the `state(dial)` callback. You can access the state of your dial by attaching the environment variable to an attribute, shown here:
```
@dial Application.get_env(:belfrage, :dial)

@dial.state(:logging_level)

```
We like to use this method of assigning the environment variable to an attribute to ensure consistency as well as using this method in tests means we are able to mock the dials server cleanly.
      
