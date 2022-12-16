defmodule Belfrage.ResponseTransformers.CachingEnabled do
  alias Belfrage.{Struct, Mvt}
  use Belfrage.Behaviours.Transformer

  @doc """
  Sets struct.private.caching_enabled depending on
  the logic here. Right now the logic simply consists
  of checking whether or not all MVT vary headers in
  the response are in :mvt_seen - if not then we
  set struct.private.caching_enabled to false.
  """
  @impl Transformer
  def call(struct = %Struct{}) do
    if Mvt.State.all_vary_headers_seen?(struct) do
      {:ok, struct}
    else
      {:ok, Struct.add(struct, :private, %{caching_enabled: false})}
    end
  end
end
