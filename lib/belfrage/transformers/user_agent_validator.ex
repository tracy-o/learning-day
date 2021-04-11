defmodule Belfrage.Transformers.UserAgentValidator do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{user_agent: "MozartFetcher"}}), do: then(rest, struct)

  def call(_rest, struct = %Struct{request: %Struct.Request{req_svc_chain: req_svc_chain}}) do
    {
      :stop_pipeline,
      Struct.add(struct, :response, %{
        http_status: 400,
        headers: %{
          "req-svc-chain" => req_svc_chain,
          "cache-control" => "private"
        }
      })
    }
  end
end
