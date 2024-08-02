defmodule Benchmarks.EnvelopePolling do
  alias Belfrage.Envelope
  import Fixtures.Envelope

  def run(_) do
    benchmark_get_route_state()
    # benchmark_get_cookie_allowlist()
    # benchmark_response_body()
  end

  # Item that can be nil or string or tuple
  defp benchmark_get_route_state do
    envelope = %Envelope{private: %Envelope.Private{route_state_id: "ProxyPass"}}
    envelope_with_no_route_state = %Envelope{}

    Benchee.run(
      %{
        "Processor.get_route_state" => fn -> Processor.get_route_state(envelope) end
      },
      inputs: %{
        route_state: envelope,
        no_route_state: envelope_with_no_route_state
      },
      time: 10,
      memory_time: 2
    )
  end
end

defmodule Processor do
  @example_route_state %{
    origin: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
    throughput: 100,
    counter: %{errors: 0},
    route_state_id: {"NewsHomePage", "Webcore"},
    circuit_breaker_error_threshold: 200,
    mvt_seen: %{}
  }

  def get_route_state(envelope) when not envelope.private.route_state_id do
    envelope
  end

  def get_route_state(envelope) do
    Map.put(envelope, :private, struct(envelope.private, @example_route_state))
  end
end
