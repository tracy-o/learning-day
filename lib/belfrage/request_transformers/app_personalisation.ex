defmodule Belfrage.RequestTransformers.AppPersonalisation do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.{Struct, Struct.Request, Personalisation}

  @doc """
  Returns a tuple with :stop as the first element and a Struct
  with struct.response.http_status set to 503 as the second element, if
  struct.request.app? equals true and Personalisation.enabled?/0 returns
  false.

  Otherwise returns {:ok, struct}.
  """
  @impl Transformer
  def call(struct = %Struct{request: %Request{app?: false}}), do: {:ok, struct}

  def call(struct = %Struct{request: %Request{app?: true}}) do
    if Personalisation.enabled?() do
      {:ok, struct}
    else
      {:stop, Struct.put_status(struct, 503)}
    end
  end
end
