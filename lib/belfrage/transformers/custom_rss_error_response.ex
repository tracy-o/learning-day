defmodule Belfrage.Transformers.CustomRssErrorResponse do
  alias Belfrage.Struct
  use Belfrage.Transformers.Transformer

  @impl true
  def call(
        rest,
        struct = %Struct{
          private: %Struct.Private{platform: Fabl},
          request: %Struct.Request{path: "/fd/rss"},
          response: %Struct.Response{http_status: http_status}
        }
      )
      when http_status > 399 do
    then_do(rest, Struct.add(struct, :response, %{body: ""}))
  end

  @impl true
  def call(rest, struct), do: then_do(rest, struct)
end
