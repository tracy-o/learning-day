defmodule Belfrage.RequestTransformers.NiElectionFailoverMode do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    if failover_mode_active?() do
      {:stop,
       Envelope.add(envelope, :response, %{
         http_status: 302,
         headers: %{
           "location" => "/news",
           "x-bbc-no-scheme-rewrite" => "1",
           "cache-control" => "public, stale-while-revalidate=10, max-age=60"
         },
         body: ""
       })}
    else
      {:ok, envelope}
    end
  end

  defp failover_mode_active? do
    @dial.state(:ni_election_failover) == "on"
  end
end
