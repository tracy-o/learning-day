defmodule Belfrage.RequestTransformers.UserAgentValidator do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Struct.Request

  @valid_user_agents ~w(MozartFetcher MozartCli fabl)

  @impl Transformer
  def call(struct = %Struct{request: request = %Request{}}) do
    if request.user_agent in @valid_user_agents do
      {:ok, struct}
    else
      {
        :stop,
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
