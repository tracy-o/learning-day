defmodule Belfrage.Clients.CCPStub do
  @behaviour Belfrage.Clients.CCP

  @impl true
  def fetch(_envelope), do: {:ok, :content_not_found}

  @impl true
  def put(_envelope), do: :ok

  @impl true
  def put(_envelope, _target), do: :ok
end
