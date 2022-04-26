defmodule Test.Support.Helper do
  def setup_stubs do
    Mox.stub_with(Belfrage.AWSMock, Belfrage.AWSStub)
    Mox.stub_with(Belfrage.Clients.CCPMock, Belfrage.Clients.CCPStub)
    Mox.stub_with(Belfrage.Authentication.Validator.ExpiryMock, Belfrage.Authentication.Validator.ExpiryStub)
    Mox.stub_with(Belfrage.EventMock, Belfrage.EventStub)
    Mox.stub_with(Belfrage.Dials.ServerMock, Belfrage.Dials.LiveServer)
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

  def get_route(endpoint, path, "WorldService" <> _language) do
    host_header =
      case String.contains?(endpoint, ".test.") do
        true -> "www.test.bbc.com"
        false -> "www.bbc.com"
      end

    request_route(endpoint, path, [{"x-forwarded-host", host_header}])
  end

  # ContainerEnvelope* route specs use `UserAgentValidator` that checks that a
  # certain user-agent header is present, otherwise a 400 response is returned
  def get_route(endpoint, path, "ContainerEnvelope" <> _spec) do
    request_route(endpoint, path, [{"x-forwarded-host", endpoint}, {"user-agent", "MozartFetcher"}])
  end

  def get_route(endpoint, path, _spec), do: get_route(endpoint, path)

  def get_route(endpoint, path) do
    request_route(endpoint, path, [{"x-forwarded-host", endpoint}])
  end

  defp request_route(endpoint, path, headers) do
    MachineGun.get!("https://#{endpoint}#{path}", headers, %{request_timeout: 10_000})
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

  def gtm_host("test"), do: "www.test.bbc.co.uk"
  def gtm_host("live"), do: "www.bbc.co.uk"

  def gtm_host_com("test"), do: "www.test.bbc.com"
  def gtm_host_com("live"), do: "www.bbc.com"

  def cdn_web_host("test"), do: "web-cdn.test.api.bbci.co.uk"
  def cdn_web_host("live"), do: "web-cdn.api.bbci.co.uk"

  def cdn_sport_host("test"), do: "sport-app.test.api.bbc.co.uk"
  def cdn_sport_host("live"), do: "sport-app.api.bbc.co.uk"

  def cdn_news_host("test"), do: "news-app.test.api.bbc.co.uk"
  def cdn_news_host("live"), do: "news-app.api.bbc.co.uk"

  def wait_for(condition, tries \\ 100) do
    unless condition.() do
      if tries > 0 do
        Process.sleep(1)
        wait_for(condition, tries - 1)
      else
        ExUnit.Assertions.flunk("Function passed to `wait_for` never returned `true`")
      end
    end
  end
end
