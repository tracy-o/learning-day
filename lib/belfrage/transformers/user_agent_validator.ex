defmodule Belfrage.Transformers.UserAgentValidator do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Request

  @valid_user_agents ~w(MozartFetcher MozartCli fabl)

  @impl true
  def call(rest, struct = %Struct{request: request = %Request{}}) do
    if request.user_agent in @valid_user_agents do
      then_do(rest, struct)
    else
      {
        :stop_pipeline,
        Struct.add(struct, :response, %{
          http_status: 400,
          headers: %{
            "req-svc-chain" => request.req_svc_chain,
            "cache-control" => "private"
          }
        })
      }
    end
  end
end
