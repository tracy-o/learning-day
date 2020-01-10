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
    Mox.stub_with(Belfrage.AWSMock, Belfrage.AWSStub)
    Mox.stub_with(Belfrage.AWS.STSMock, Belfrage.AWS.STSStub)
    Mox.stub_with(Belfrage.AWS.LambdaMock, Belfrage.AWS.LambdaStub)
  end

  def mox do
    quote do
      import Mox
      setup :verify_on_exit!
      setup :set_mox_global

      setup do
        Test.Support.Helper.setup_stubs()

        :ok
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
