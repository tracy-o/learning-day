defmodule Belfrage.RequestTransformers.IsCommercial do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Brands, Envelope}

  @impl Transformer
  def call(envelope = %Envelope{}) do
    if Brands.is_bbcx?(envelope) do
      {:ok,
       Envelope.add(envelope, :request, %{
         raw_headers: %{"is_commercial" => "true"}
       })}
    else
      {:ok, envelope}
    end
  end
end
