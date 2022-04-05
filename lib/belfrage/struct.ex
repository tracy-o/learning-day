defmodule Belfrage.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Belfrage.Struct.Request do
  @derive {Inspect, except: [:raw_headers, :cookies]}
  defstruct [
    :path,
    :payload,
    :method,
    :country,
    :request_hash,
    :scheme,
    :host,
    :is_uk,
    :is_advertise,
    :language,
    :xray_segment,
    :accept_encoding,
    :req_svc_chain,
    :request_id,
    :user_agent,
    edge_cache?: false,
    cdn?: false,
    has_been_replayed?: nil,
    origin_simulator?: nil,
    subdomain: "www",
    raw_headers: %{},
    query_params: %{},
    path_params: %{},
    cookies: %{},
    x_candy_audience: %{},
    x_candy_override: %{},
    x_candy_preview_guid: %{},
    x_morph_env: %{},
    x_use_fixture: %{},
    cookie_ckps_language: %{},
    cookie_ckps_chinese: %{},
    cookie_ckps_serbian: %{},
    origin: nil,
    referer: nil,
    app?: false
  ]

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Struct.Response do
  defstruct fallback: false,
            http_status: nil,
            headers: %{},
            body: "",
            cache_directive: %Belfrage.CacheControl{cacheability: "private"},
            cache_last_updated: nil,
            cache_type: nil,
            personalised_route: false

  @type t :: %__MODULE__{}

  def add_headers(response = %__MODULE__{}, headers) do
    Map.put(response, :headers, Map.merge(Map.get(response, :headers), headers))
  end
end

defmodule Belfrage.Struct.Private do
  defstruct fallback_ttl: :timer.hours(6),
            route_state_id: nil,
            candidate_route_state_ids: [],
            origin: nil,
            counter: %{},
            circuit_breaker_error_threshold: nil,
            pipeline: [],
            overrides: %{},
            query_params_allowlist: [],
            headers_allowlist: [],
            cookie_allowlist: [],
            production_environment: "live",
            platform: nil,
            signature_keys: %{skip: [], add: []},
            preview_mode: "off",
            default_language: "en-GB",
            owner: nil,
            runbook: nil,
            personalised_route: false,
            personalised_request: false,
            caching_enabled: true,
            features: %{},
            mvt: %{},
            mvt_project_id: 0,
            mvt_vary: [],
            language_from_cookie: false,
            throughput: 100

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Struct.UserSession do
  @derive {Inspect, except: [:session_token, :user_attributes]}

  defstruct authentication_env: nil,
            session_token: nil,
            authenticated: false,
            valid_session: false,
            user_attributes: %{}
end

defmodule Belfrage.Struct do
  alias Belfrage.Logger.HeaderRedactor

  defstruct request: %Belfrage.Struct.Request{},
            private: %Belfrage.Struct.Private{},
            user_session: %Belfrage.Struct.UserSession{},
            response: %Belfrage.Struct.Response{},
            debug: %Belfrage.Struct.Debug{}

  @type t :: %__MODULE__{}

  def add(struct, key, values) do
    Map.put(struct, key, Map.merge(Map.get(struct, key), values))
  end

  def loggable(struct) do
    struct
    |> update_in([Access.key(:response), Access.key(:body)], fn _value -> "REMOVED" end)
    |> update_in([Access.key(:request), Access.key(:raw_headers)], &HeaderRedactor.redact/1)
    |> update_in([Access.key(:request), Access.key(:cookies)], fn _value -> "REMOVED" end)
    |> update_in([Access.key(:response), Access.key(:headers)], &HeaderRedactor.redact/1)
    |> update_in([Access.key(:user_session), Access.key(:session_token)], fn
      nil -> nil
      _value -> "REDACTED"
    end)
  end
end
