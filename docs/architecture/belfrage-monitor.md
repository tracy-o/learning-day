# Belfrage Monitor has been deprecated and retired.
**We retired monitor as it was not being used and was no longer adding as much value for us. 
Monitor may return in the future but for now it will remain inactive.
Feel free to read on, but keep in mind that monitor is no longer active.**
---
### Summary
A separate Elixir app named "Monitor", receives introspective runtime events from Belfrage. This is done via lightweight OTP message passing. It helps developers to debug requests, analyse the state of Belfrage without impacting the main flow of traffic, and share this data with any technology or team who desires it.

![Belfrage Monitor diagram](https://github.com/bbc/belfrage/blob/master/docs/img/belfrage-monitor.png?raw=true)

### Availability
Messages sent from Belfrage are cast, (fire-and-forget) messages. This means that Belfrage is not dependent upon the availability of the Monitor app.

The crucial metrics that Belfrage uses to scale, and trigger the circuit breaker are still internal to Belfrage, and therefore there is no critical link to the Monitor app.

### RPC (Remote Procedure Call) Messages
An `rpc` cast includes 4 pieces of information: The module name, function name, arguments, and a reference to the sending node's "group leader". When the cast message is received by the remote node, it will use the `apply/3` function to call the function in the given module, with the given arguments. By default, the `Logger` module will forward back any log events to the sending node by inspecting the "group leader" value, in addition to logging on the remote node itself.

### Ephemeral Storage
Currently all events from Belfrage are stored in an ETS table (in-memory) on a single Monitor instance. Events will stay as long as there is available memory. Older events will be removed first when the available memory runs out.

### Links
[Monitor on GitHub](https://github.com/bbc/belfrage-monitor)

[Monitor UI on GitHub](https://github.com/bbc/belfrage-monitor-ui)

[Monitor on Cosmos](https://cosmos.tools.bbc.co.uk/services/monitor)

[Erlang logger proxy](https://erlang.org/doc/apps/kernel/logger_chapter.html#logger-proxy)