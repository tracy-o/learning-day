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
end
