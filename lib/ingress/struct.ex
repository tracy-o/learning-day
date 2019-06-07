defmodule Ingress.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Ingress.Struct.Request do
  defstruct [:path, :payload, :method, :country, :request_hash]
end

defmodule Ingress.Struct.Response do
  # TODO: When we start serving personalised pages, we should default to `cacheable_content: false`
  defstruct http_status: nil, headers: %{}, body: nil, cacheable_content: true
end

defmodule Ingress.Struct.Private do
  defstruct fallback_ttl: :timer.hours(6),
            cache_ttl: 30,
            loop_id: nil,
            origin: nil,
            counter: %{},
            pipeline: []
end

defmodule Ingress.Struct do
  defstruct request: %Ingress.Struct.Request{},
            private: %Ingress.Struct.Private{},
            response: %Ingress.Struct.Response{},
            debug: %Ingress.Struct.Debug{}

  def add(struct, key, values) do
    Map.put(struct, key, Map.merge(Map.get(struct, key), values))
  end
end
