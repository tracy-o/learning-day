defmodule Belfrage.RequestTransformers.AppPersonalisationHalter do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Envelope, Envelope.Request, Personalisation}

  @doc """
  Returns a tuple with :stop as the first element and a Envelope
  with envelope.response.http_status set to 204 as the second element, if
  envelope.request.app? equals true and Personalisation.enabled?/0 returns
  false.

  Otherwise returns {:ok, envelope}.
  """
  @impl Transformer
  def call(envelope = %Envelope{request: %Request{app?: false}}), do: {:ok, envelope}

  def call(envelope = %Envelope{request: %Request{app?: true}}) do
    if Personalisation.enabled?() do
      {:ok, envelope}
    else
      {:stop, Envelope.put_status(envelope, 204)}
    end
  end
end
