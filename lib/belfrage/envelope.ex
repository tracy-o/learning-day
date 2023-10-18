defmodule Belfrage.Envelope.Debug do
  defstruct preflight_pipeline_trail: [],
            request_pipeline_trail: [],
            response_pipeline_trail: []
end

defmodule Belfrage.Envelope.Request do
  @derive {Inspect, except: [:raw_headers, :cookies]}
  defstruct [
    :path,
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
    x_candy_audience: nil,
    x_candy_override: nil,
    x_candy_preview_guid: nil,
    x_morph_env: nil,
    x_use_fixture: nil,
    cookie_ckps_language: nil,
    cookie_ckps_chinese: nil,
    cookie_ckps_serbian: nil,
    origin: nil,
    referer: nil,
    app?: false
  ]

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Envelope.Response do
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

defmodule Belfrage.Envelope.Private do
  defstruct fallback_ttl: :timer.hours(6),
            route_state_id: nil,
            candidate_route_state_ids: [],
            origin: nil,
            counter: %{},
            circuit_breaker_error_threshold: nil,
            request_pipeline: [],
            response_pipeline: [],
            overrides: %{},
            checkpoints: %{},
            query_params_allowlist: [],
            headers_allowlist: [],
            cookie_allowlist: [],
            production_environment: "live",
            spec: nil,
            platform: nil,
            partition: nil,
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
            throughput: 100,
            fallback_write_sample: 1,
            etag: false,
            metadata: %{},
            xray_enabled: false,
            bbcx_enabled: false,
            preflight_metadata: %{}

  @type t :: %__MODULE__{}
end

defmodule Belfrage.Envelope.UserSession do
  @derive {Inspect, except: [:session_token, :user_attributes]}

  defstruct authentication_env: nil,
            session_token: nil,
            authenticated: false,
            valid_session: false,
            user_attributes: %{}
end

defmodule Belfrage.Envelope do
  alias Belfrage.Logger.HeaderRedactor
  alias Plug.Conn

  defstruct request: %Belfrage.Envelope.Request{},
            private: %Belfrage.Envelope.Private{},
            user_session: %Belfrage.Envelope.UserSession{},
            response: %Belfrage.Envelope.Response{},
            debug: %Belfrage.Envelope.Debug{}

  @type t :: %__MODULE__{}

  def add(envelope, key, values) do
    Map.put(envelope, key, Map.merge(Map.get(envelope, key), values))
  end

  def loggable(envelope) do
    envelope
    |> update_in([Access.key(:response), Access.key(:body)], fn _value -> "REMOVED" end)
    |> update_in([Access.key(:request), Access.key(:raw_headers)], &HeaderRedactor.redact/1)
    |> update_in([Access.key(:request), Access.key(:cookies)], fn _value -> "REMOVED" end)
    |> update_in([Access.key(:response), Access.key(:headers)], &HeaderRedactor.redact/1)
    |> update_in([Access.key(:user_session), Access.key(:session_token)], fn
      nil -> nil
      _value -> "REDACTED"
    end)
    |> update_in([Access.key(:user_session), Access.key(:user_attributes)], fn _value -> "REMOVED" end)
  end

  def put_status(envelope, code) when is_number(code) do
    add(envelope, :response, %{http_status: code})
  end

  def put_checkpoint(envelope, name, value) do
    update_in(envelope.private.checkpoints, &Map.put(&1, name, value))
  end

  def get_checkpoints(envelope) do
    envelope.private.checkpoints
  end

  def adapt_private(envelope, private, spec) do
    add(envelope, :private, %{
      spec: spec,
      overrides: private.overrides,
      production_environment: private.production_environment,
      preview_mode: private.preview_mode
    })
  end

  def adapt_request(envelope, conn = %Conn{private: %{bbc_headers: bbc_headers}}) do
    add(envelope, :request, %{
      path: conn.request_path,
      raw_headers: raw_headers(conn),
      method: conn.method,
      country: bbc_headers.country,
      path_params: conn.path_params,
      query_params: conn.query_params,
      scheme: bbc_headers.scheme,
      host: bbc_headers.host || conn.host,
      has_been_replayed?: bbc_headers.replayed_traffic,
      origin_simulator?: bbc_headers.origin_simulator,
      subdomain: subdomain(conn),
      edge_cache?: bbc_headers.cache,
      cdn?: bbc_headers.cdn,
      xray_segment: conn.assigns[:xray_segment],
      accept_encoding: accept_encoding(conn),
      is_uk: bbc_headers.is_uk,
      is_advertise: bbc_headers.is_advertise,
      req_svc_chain: bbc_headers.req_svc_chain,
      request_id: conn.private.request_id,
      x_candy_audience: bbc_headers.x_candy_audience,
      x_candy_override: bbc_headers.x_candy_override,
      x_candy_preview_guid: bbc_headers.x_candy_preview_guid,
      x_morph_env: bbc_headers.x_morph_env,
      x_use_fixture: bbc_headers.x_use_fixture,
      cookie_ckps_language: bbc_headers.cookie_ckps_language,
      cookie_ckps_chinese: bbc_headers.cookie_ckps_chinese,
      cookie_ckps_serbian: bbc_headers.cookie_ckps_serbian,
      origin: bbc_headers.origin,
      referer: bbc_headers.referer,
      user_agent: bbc_headers.user_agent,
      app?: app?(conn)
    })
  end

  defp raw_headers(conn), do: Enum.into(conn.req_headers, %{})

  defp subdomain(%Conn{host: host}) when bit_size(host) > 0 do
    host
    |> String.split(".")
    |> List.first()
  end

  defp subdomain(_conn), do: "www"

  defp accept_encoding(conn) do
    case Conn.get_req_header(conn, "accept-encoding") do
      [accept_encoding] -> accept_encoding
      [] -> nil
    end
  end

  defp app?(conn) do
    conn
    |> subdomain()
    |> String.contains?("app")
  end
end
