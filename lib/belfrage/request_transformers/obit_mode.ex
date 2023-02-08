defmodule Belfrage.RequestTransformers.ObitMode do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{raw_headers: raw_headers}}) do
    struct =
      Struct.add(struct, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "obit-mode" => @dial.state(:obit_mode)
          })
      })

    {:ok, struct}
  end
end
