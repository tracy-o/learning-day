defmodule Belfrage.ResponseTransformers.CachingEnabled do
  alias Belfrage.{Envelope, Mvt}
  use Belfrage.Behaviours.Transformer

  @doc """
  Sets envelope.private.caching_enabled depending on
  the logic here. Right now the logic simply consists
  of checking whether or not all MVT vary headers in
  the response are in :mvt_seen - if not then we
  set envelope.private.caching_enabled to false.
  """
  @impl Transformer
  def call(envelope = %Envelope{}) do
    if Mvt.State.all_vary_headers_seen?(envelope) do
      {:ok, envelope}
    else
      {:ok, Envelope.add(envelope, :private, %{caching_enabled: false})}
    end
  end
end
