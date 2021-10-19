# Best Practices in Elixir testing.
### General rules
```
1. Every test file should try to be configured as async: true where possible
2. Use Mox to mock external or extraneous services.
3. Use start_supervised to start unique GenServers or other required async processes in the setup block of that test.
4. GenServers/Supervisors need to be made configurable on startup.
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