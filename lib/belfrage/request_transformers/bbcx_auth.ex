defmodule Belfrage.RequestTransformers.BBCXAuth do
  use Belfrage.Behaviours.Transformer

  #
  # https://datatracker.ietf.org/doc/html/rfc7617#section-2
  #
  @auth_scheme "Basic " <> Base.encode64("bbcx:cihWhx2WAaQrMSUaw1N9B0tq")

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{raw_headers: raw_headers}}) do
    envelope =
      Envelope.add(envelope, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "authorization" => @auth_scheme
          })
      })

    {:ok, envelope}
  end
end
