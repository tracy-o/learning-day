defmodule Ingress.Struct do
  defstruct request: Ingress.Struct.Request,
            private: Ingress.Struct.Private,
            response: Ingress.Struct.Response,
            debug: Ingress.Struct.Debug
end

defmodule Ingress.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Ingress.Struct.Request do
  @enforce_keys [:path, :method]
  defstruct [:path, :payload, :method]
end

defmodule Ingress.Struct.Response do
  @enforce_keys [:http_status, :body]
  defstruct http_status: nil, headers: %{}, body: nil
end

defmodule Ingress.Struct.Private do
  @enforce_keys [:loop_id]
  defstruct loop_id: nil, origin: nil, counter: %{}, pipeline: []
end
