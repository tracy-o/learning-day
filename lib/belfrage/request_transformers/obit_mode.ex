defmodule Belfrage.RequestTransformers.ObitMode do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{raw_headers: raw_headers}}) do
    envelope =
      Envelope.add(envelope, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "obit-mode" => @dial.get_dial(:obit_mode)
          })
      })

    {:ok, envelope}
  end
end
