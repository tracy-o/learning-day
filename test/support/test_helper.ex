defmodule Test.Support.Helper do
  @doc "Inserts cache seed in the format Cachex expects it to be in."
  def insert_cache_seed(
        id: id,
        response: response,
        expires_in: expires_in,
        last_updated: last_updated
      ) do
    item_to_store = {response, last_updated}

    :ets.insert(
      :cache,
      {:entry, id, last_updated, expires_in, item_to_store}
    )
  end

  def setup_stubs do
    Mox.set_mox_global()
    Mox.stub_with(Belfrage.Helpers.FileIOMock, Belfrage.Helpers.FileIOStub)
    Mox.stub_with(Belfrage.AWSMock, Belfrage.AWSStub)
    Mox.stub_with(Belfrage.AWS.STSMock, Belfrage.AWS.STSStub)
    Mox.stub_with(Belfrage.AWS.LambdaMock, Belfrage.AWS.LambdaStub)
    Mox.stub_with(Belfrage.XrayMock, Belfrage.XrayStub)
    Mox.stub_with(CacheStrategyMock, CacheStrategyStub)
    Mox.stub_with(CacheStrategyTwoMock, CacheStrategyStub)
    Mox.stub_with(Belfrage.Clients.CCPMock, Belfrage.Clients.CCPStub)
    Mox.stub_with(Belfrage.Dials.DialMock, Belfrage.Dials.DialStub)
    Mox.stub_with(Belfrage.Dials.DialMockWithOptionalCallback, Belfrage.Dials.DialStub)
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

  def mox do
    quote do
      import Mox
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

  def get_route(endpoint, path, :pal) do
    MachineGun.get!("https://#{endpoint}#{path}", [{"x-bbc-edge-scheme", "https"}, {"x-bbc-edge-cache", "1"}], %{})
  end

  def get_route(endpoint, path) do
    MachineGun.get!("https://#{endpoint}#{path}", [{"x-forwarded-host", endpoint}], %{})
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
end
