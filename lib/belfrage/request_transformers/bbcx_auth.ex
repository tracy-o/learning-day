defmodule Belfrage.RequestTransformers.BBCX_auth do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{raw_headers: raw_headers}}) do
    credentials = "bbcx:cihWhx2WAaQrMSUaw1N9B0tq"

    envelope =
      Envelope.add(envelope, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "authorization" => "Basic " <> Base.encode64(credentials)
          })
      })

    {:ok, envelope}
  end
end
