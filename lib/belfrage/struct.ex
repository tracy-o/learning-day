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
    :language,
    :language_chinese,
    :language_serbian,
    :xray_trace_id,
    :accept_encoding,
    :req_svc_chain,
    varnish?: false,
    edge_cache?: false,
    cdn?: false,
    has_been_replayed?: nil,
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
  defstruct fallback_ttl: :timer.hours(6),
            loop_id: nil,
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
            preview_mode: "off"

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
    |> redact(:response, :body, fn _value -> "REMOVED" end)
    |> redact(:request, :raw_headers, &Belfrage.PII.clean/1)
    |> redact(:response, :headers, &Belfrage.PII.clean/1)
  end

  defp redact(struct, top_level, key, clean_func) do
    struct
    |> get_and_update_in([Access.key(top_level), Access.key(key)], &{&1, clean_func.(&1)})
    |> elem(1)
  end
end
