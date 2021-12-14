# Best Practices in Elixir testing.
### General rules
```
1. Every test file should try to be configured as async: true where possible
2. Use Mox to mock external or extraneous services.
3. Use start_supervised to start unique GenServers or other required async processes in the setup block of that test.
4. GenServers/Supervisors need to be made configurable on startup.
```
### How to run tests
To run unit and integration tests:
```
mix test
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


### Blocking expectations
Testing code ran in different processes can result in race conditions. These can be difficult to test. You have a couple of options.

1. When background process uses a mock
```
test "calling a mock from a different process" do
  parent = self()
  ref = make_ref()

  expect(MyApp.MockWeatherAPI, :temp, fn _loc ->
    send(parent, {ref, :temp})
    {:ok, 30}
  end)

  spawn(fn -> MyApp.HumanizedWeather.temp({50.06, 19.94}) end)

  assert_receive {^ref, :temp}

  verify!()
end
```

2. Test the code running in the background in isolation.
Avoid the problem by testing the code running in the other process directly.

3. Call the GenServer after a cast, even if the state isn't used
```
GenServer.cast(SomeServer, :do_something)

# Wait for the previous message to be handled by the server.
:sys.get_state(SomeServer)

# continue the test...
```
