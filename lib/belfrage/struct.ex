defmodule Belfrage.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Belfrage.Struct.Request do
  defstruct [:path, :payload, :method, :country, :request_hash, :query_params, has_been_replayed?: nil]
end

defmodule Belfrage.Struct.Response do
  # TODO: When we start serving personalised pages, we should default to `cacheable_content: false`
  defstruct [:fallback, http_status: nil, headers: %{}, body: nil, cacheable_content: true]
end

defmodule Belfrage.Struct.Private do
  defstruct fallback_ttl: :timer.hours(6),
            cache_ttl: 30,
            loop_id: nil,
            origin: nil,
            counter: %{},
            pipeline: []
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
