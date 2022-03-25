defmodule Belfrage.Test.XrayHelper do
  alias AwsExRay.{Trace, Segment}

  defmacro __using__(_opts) do
    quote do
      import Belfrage.Test.XrayHelper, only: [build_segment: 1]

      defmodule MockXrayClient do
        def send(data) do
          send(self(), {:mock_xray_client_data, data})
        end
      end

      defmodule MockXray do
        alias AwsExRay.{Trace, Segment}

        def start_tracing(name), do: build_segment(sampled: true, name: name)
        defdelegate parse_header(name, trace_header), to: Belfrage.Xray
        defdelegate start_subsegment(segment, name), to: Belfrage.Xray
        defdelegate set_start_time(subsegment, start_time), to: Belfrage.Xray
        defdelegate add_annotations(segment, annotations), to: Belfrage.Xray
        defdelegate add_struct_annotations(segment, struct), to: Belfrage.Xray
        defdelegate add_metadata(segment, metadata), to: Belfrage.Xray
        defdelegate set_http_request(segment, request_info), to: Belfrage.Xray
        defdelegate set_http_response(segment, response_info), to: Belfrage.Xray
        defdelegate build_trace_id_header(segment), to: Belfrage.Xray
        defdelegate finish(segment), to: Belfrage.Xray
        defdelegate finish(subsegment, end_time), to: Belfrage.Xray
        def send(segment), do: Belfrage.Xray.send(segment, MockXrayClient)
      end
    end
  end

  def build_segment(opts) do
    sampled = Keyword.get(opts, :sampled, true)
    name = Keyword.get(opts, :name, "test_segment")

    trace = %{Trace.new() | sampled: sampled}
    Segment.new(trace, name)
  end
end
