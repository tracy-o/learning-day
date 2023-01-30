defmodule Belfrage.ResponseTransformers.CustomRssErrorResponse do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(
        struct = %Struct{
          private: %Struct.Private{platform: "Fabl"},
          request: %Struct.Request{path: "/fd/rss"},
          response: %Struct.Response{http_status: http_status}
        }
      )
      when http_status > 399 do
    {:ok, Struct.add(struct, :response, %{body: ""})}
  end

  def call(struct), do: {:ok, struct}
end
