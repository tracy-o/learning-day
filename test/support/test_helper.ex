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

  def mox do
    quote do
      import Mox
      setup :verify_on_exit!
      setup :set_mox_global
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
