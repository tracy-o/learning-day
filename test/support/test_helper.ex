defmodule Test.Support.Helper do
  import ExUnit.Callbacks, only: [on_exit: 1]

  def setup_stubs do
    Mox.stub_with(Belfrage.AWSMock, Belfrage.AWSStub)
    Mox.stub_with(Belfrage.Clients.CCPMock, Belfrage.Clients.CCPStub)
    Mox.stub_with(Belfrage.Authentication.Validator.ExpiryMock, Belfrage.Authentication.Validator.ExpiryStub)
    Mox.stub_with(Belfrage.Dials.StateMock, Belfrage.Dials.StateStub)
  end

  defmacro assert_gzipped(compressed, should_be) do
    quote do
      assert :zlib.gunzip(unquote(compressed)) == unquote(should_be)
    end
  end

  defmacro assert_valid_request_hash(request_hash) do
    quote do
      assert byte_size(unquote(request_hash)) > 0
    end
  end

  # This is used by tests that set Mox expectations.
  #
  # It sets Mox mode (global or private) based on the `async` tag: if a test is
  # async, Mox will be used in private mode.
  #
  # It also sets up stubs for some of the mocked modules. We do this here in
  # addition to doing it in `test/test_helper.exs` because otherwise tests
  # won't be able to:
  # * Set Mox expectations. Mox is put in global mode in `test/test_helper.exs`
  # and only the process that puts Mox in global mode (i.e. the Mix process
  # that runs tests) can set expectations. Tests are executed in separate
  # processes and so they can't.
  # * Use stubs set up in `test/test_helper.exs`. When we enable global mode
  # for Mox in a test, the test process can no longer call a stub that was
  # enabled in `test/test_helper.exs` because that was done by a different
  # process (the Mix process that runs tests) which is no longer the global
  # process in Mox.
  def mox do
    quote do
      import Mox
      import Belfrage.Test.StubHelper

      setup :set_mox_from_context
      setup :verify_on_exit!

      setup do
        Test.Support.Helper.setup_stubs()

        :ok
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def get_route(endpoint, path), do: get_route(endpoint, path, [])

  def get_route(endpoint, path, headers) do
    Finch.build(:get, "https://#{endpoint}#{path}", headers)
    |> Finch.request(Finch, receive_timeout: 10_000)
  end

  def header_item_exists(headers, header_id) do
    Enum.any?(headers, fn {id, value} -> id == header_id.id and value == header_id.value end)
  end

  def get_header(headers, find_name) do
    Enum.find_value(headers, fn
      {^find_name, value} -> value
      _header -> nil
    end)
  end

  def gtm_host(), do: "www.bbc.co.uk"

  def gtm_host_com(), do: "www.bbc.com"

  def cdn_web_host(), do: "web-cdn.api.bbci.co.uk"

  def cdn_sport_host(), do: "sport-app.api.bbc.co.uk"

  def cdn_news_host(), do: "news-app.api.bbc.co.uk"

  def wait_for(condition, tries \\ 100, sleep_interval_ms \\ 1) do
    unless condition.() do
      if tries > 0 do
        Process.sleep(sleep_interval_ms)
        wait_for(condition, tries - 1)
      else
        ExUnit.Assertions.flunk("Function passed to `wait_for` never returned `true`")
      end
    end
  end

  def set_stack_id(id) do
    prev_id = Application.get_env(:belfrage, :stack_id)
    Application.put_env(:belfrage, :stack_id, id)

    on_exit(fn -> Application.put_env(:belfrage, :stack_id, prev_id) end)
  end

  def set_environment(env) do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, env)
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)
    :ok
  end

  def set_env(name, value) do
    original_value = Application.get_env(:belfrage, name)
    Application.put_env(:belfrage, name, value)
    on_exit(fn -> Application.put_env(:belfrage, name, original_value) end)
  end

  def set_env(app, name, value) do
    original_value = Application.get_env(app, name)
    Application.put_env(app, name, value)
    on_exit(fn -> Application.put_env(app, name, original_value) end)
  end

  def set_env(app, name, value, on_exit_fun) do
    original_value = Application.get_env(app, name)
    Application.put_env(app, name, value)

    on_exit(fn ->
      Application.put_env(app, name, original_value)
      on_exit_fun.()
    end)
  end

  def set_slots(project) do
    Belfrage.Mvt.Slots.set(%{"1" => project})
    on_exit(fn -> Belfrage.Mvt.Slots.set(%{}) end)
    :ok
  end

  def set_bbc_id_availability(availability) do
    orig_availability = Belfrage.Authentication.BBCID.available?()
    Belfrage.Authentication.BBCID.set_opts(%{id_availability: availability})
    on_exit(fn -> Belfrage.Authentication.BBCID.set_opts(%{id_availability: orig_availability}) end)
    :ok
  end

  def set_logging_level(level)
      when level in [:emergency, :alert, :critical, :error, :warning, :warn, :notice, :info, :debug] do
    previous_level = Logger.level()
    Logger.configure(level: level)
    on_exit(fn -> Logger.configure(level: previous_level) end)
  end

  @doc """
  Takes a process ID and an interval in milliseconds.
  The function sleeps for the duration of the interval,
  and then returns true if the process is still alive and
  false if it is not.
  """
  def alive_after?(pid, interval_ms \\ 100) do
    Process.sleep(interval_ms)
    Process.alive?(pid)
  end
end
