# Struct

The struct is how Belfrage keeps track of the connection throughout its entire lifetime. It is an Elixir struct (terrible naming we know) which is similar to a map but has default keys. It is designed in a way so at any point in a connections lifetime you could inspect the struct and see the exact state of the connection.

The struct currently contains five main sections:
- Debug
    - A section in which we, as developers, can add information that may contain non essential information about a request that allow us to debug.
    - Currently only contains the `pipeline_trail` which is used to view which transformers your response has been through
- Request
    - The request section contains all information we are provided with when a connection comes into Belfrage.
    - Example keys: `path`: '/news/story/123', `method`: 'GET', `request_hash`: 'abc123'
- Response
    - This section contains various keys regarding our reply to the request.
    - Example keys: `http_status`:200, `body`: 'Hello! This is the body'
- Private
    - This section contains data which is not passed down to later services, just for use within Belfrage.
    - Example keys: `route_state_id`: HomePage, `personalised_route`: false
- UserSession
    - This section of the struct keeps track of all the information required for a logged in user
    - Example keys: `session_token`: "abc123", `authenticated`: true

The struct is defined here:[ belfrage/lib/belfrage/struct.ex ](https://github.com/bbc/belfrage/blob/master/lib/belfrage/struct.ex)
The struct life cycle can be found [here](../img/struct_lifecycle.png)
