defmodule Belfrage.Clients.CCPStub do
  @behaviour Belfrage.Clients.CCP

  @impl true
  def fetch(_struct, _request_id), do: {:ok, :content_not_found}

  @impl true
  def put(_struct), do: :ok

  @impl true
  def put(_struct, _target), do: :ok
end
