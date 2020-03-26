defmodule Belfrage.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Belfrage.Struct.Request do
  defstruct [
    :path,
    :payload,
    :method,
    :country,
    :request_hash,
    :scheme,
    :host,
    :is_uk,
    :xray_trace_id,
    :accept_encoding,
    varnish?: false,
    edge_cache?: false,
    has_been_replayed?: nil,
    subdomain: "www",
    query_params: %{},
    path_params: %{}
  ]
end

defmodule Belfrage.Struct.Response do
  defstruct fallback: false,
            http_status: nil,
            headers: %{},
            body: nil,
            cache_directive: %{cacheability: "private", max_age: 0, stale_if_error: 0, stale_while_revalidate: 0}
end

defmodule Belfrage.Struct.Private do
  defstruct fallback_ttl: :timer.hours(6),
            loop_id: nil,
            origin: nil,
            counter: %{},
            long_counter: %{},
            circuit_breaker_error_threshold: nil,
            pipeline: [],
            overrides: %{},
            query_params_allowlist: [],
            production_environment: "live",
            platform: nil,
            preview_mode: "off"
end

defmodule Belfrage.Struct do
  defstruct request: %Belfrage.Struct.Request{},
            private: %Belfrage.Struct.Private{},
            response: %Belfrage.Struct.Response{},
            debug: %Belfrage.Struct.Debug{}

  def add(struct, key, values) do
    Map.put(struct, key, Map.merge(Map.get(struct, key), values))
  end
end
