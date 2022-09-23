defmodule Belfrage.ResponseTransformers.CustomRssErrorResponse do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(
        struct = %Struct{
          private: %Struct.Private{platform: Fabl},
          request: %Struct.Request{path: "/fd/rss"},
          response: %Struct.Response{http_status: http_status}
        }
      )
      when http_status > 399 do
    Struct.add(struct, :response, %{body: ""})
  end

  def call(struct) do
    struct
  end
end
