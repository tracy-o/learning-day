defmodule Belfrage.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Belfrage.Struct.Request do
  @derive {Inspect, except: [:xray_trace_id, :raw_headers]}
  defstruct [
    :path,
    :payload,
    :method,
    :country,
    :request_hash,
    :scheme,
    :host,
    :is_uk,
    :language,
    :xray_trace_id,
    :accept_encoding,
    :req_svc_chain,
    :request_id,
    edge_cache?: false,
    cdn?: false,
    has_been_replayed?: nil,
    origin_simulator?: nil,
    subdomain: "www",
    raw_headers: %{},
    query_params: %{},
    path_params: %{}
  ]

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Struct.Response do
  defstruct fallback: false,
            http_status: nil,
            headers: %{},
            body: "",
            cache_directive: %Belfrage.CacheControl{cacheability: "private"}

  @type t :: %__MODULE__{}

  def add_headers(response = %__MODULE__{}, headers) do
    Map.put(response, :headers, Map.merge(Map.get(response, :headers), headers))
  end
end

defmodule Belfrage.Struct.Private do
  @derive {Inspect, except: [:signature_keys, :authenticated, :session_token]}
  defstruct fallback_ttl: :timer.hours(6),
            loop_id: nil,
            candidate_loop_ids: [],
            origin: nil,
            counter: %{},
            long_counter: %{},
            circuit_breaker_error_threshold: nil,
            pipeline: [],
            overrides: %{},
            query_params_allowlist: [],
            headers_allowlist: [],
            production_environment: "live",
            platform: nil,
            signature_keys: %{skip: [], add: []},
            preview_mode: "off",
            default_language: "en-GB",
            authenticated: false,
            session_token: nil

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Struct do
  defstruct request: %Belfrage.Struct.Request{},
            private: %Belfrage.Struct.Private{},
            response: %Belfrage.Struct.Response{},
            debug: %Belfrage.Struct.Debug{}

  @type t :: %__MODULE__{}

  def add(struct, key, values) do
    Map.put(struct, key, Map.merge(Map.get(struct, key), values))
  end

  def loggable(struct) do
    struct
    |> update_in([Access.key(:response), Access.key(:body)], fn _value -> "REMOVED" end)
    |> update_in([Access.key(:request), Access.key(:raw_headers)], &Belfrage.PII.clean/1)
    |> update_in([Access.key(:response), Access.key(:headers)], &Belfrage.PII.clean/1)
  end
end
