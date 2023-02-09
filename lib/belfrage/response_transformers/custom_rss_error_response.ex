defmodule Belfrage.ResponseTransformers.CustomRssErrorResponse do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(
        envelope = %Envelope{
          private: %Envelope.Private{platform: "Fabl"},
          request: %Envelope.Request{path: "/fd/rss"},
          response: %Envelope.Response{http_status: http_status}
        }
      )
      when http_status > 399 do
    {:ok, Envelope.add(envelope, :response, %{body: ""})}
  end

  def call(envelope), do: {:ok, envelope}
end
