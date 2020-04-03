defmodule Belfrage.Clients.CCPStub do
  @behaviour Belfrage.Clients.CCP

  @impl true
  def fetch(_struct), do: {:ok, :content_not_found}

  @impl true
  def put(_struct), do: :ok

  @impl true
  def put(_struct, _target), do: :ok
end
