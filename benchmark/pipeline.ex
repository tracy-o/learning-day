defmodule Benchmark.Pipeline do
  import Fixtures.Envelope
  alias Belfrage.{Envelope, Processor}

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    benchmark_get_route_state()
    benchmark_request_pipeline()
    benchmark_response_pipeline()
  end

  defp benchmark_get_route_state do
    envelope = %Envelope{private: %Envelope.Private{route_state_id: "ProxyPass"}}

    Benchee.run(
      %{
        "Processor.get_route_state" => fn -> Processor.get_route_state(envelope) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp benchmark_request_pipeline do
    envelope = %Envelope{
      private: %Envelope.Private{request_pipeline: ["MyTransformer1"], route_state_id: "ProxyPass"}
    }

    Benchee.run(
      %{
        "Processor.request_pipeline" => fn -> Processor.request_pipeline(envelope) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp benchmark_response_pipeline do
    envelope =
      %Envelope{
        private: %Envelope.Private{request_pipeline: ["MyTransformer1"], route_state_id: "ProxyPass"}
      }
      |> envelope_with_gzip_resp()

    Benchee.run(
      %{
        "Processor.response_pipeline" => fn -> Processor.response_pipeline(envelope) end
      },
      time: 10,
      memory_time: 2
    )
  end
end
