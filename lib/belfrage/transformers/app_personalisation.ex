defmodule Belfrage.Transformers.AppPersonalisation do
  use Belfrage.Transformers.Transformer
  alias Belfrage.{Struct, Struct.Request, Personalisation}

  @doc """
  Returns a tuple with :stop_pipeline as the first element and a Struct
  with struct.response.http_status set to 503 as the second element, if
  struct.request.app? equals true and Personalisation.enabled?/0 returns
  false.

  Otherwise calls then_do(rest, struct).
  """
  def call(rest, struct = %Struct{request: %Request{app?: false}}) do
    then_do(rest, struct)
  end

  def call(rest, struct = %Struct{request: %Request{app?: true}}) do
    if Personalisation.enabled?() do
      then_do(rest, struct)
    else
      {:stop_pipeline, Struct.put_status(struct, 503)}
    end
  end
end
