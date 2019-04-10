defmodule Ingress.Struct.Debug do
  defstruct pipeline_trail: []
end

defmodule Ingress.Struct.Request do
  defstruct [:path, :payload, :method]
end

defmodule Ingress.Struct.Response do
  defstruct [http_status: nil, headers: %{}, body: nil]
end

defmodule Ingress.Struct.Private do
  defstruct loop_id: nil, origin: nil, counter: %{}, pipeline: []
end

defmodule Ingress.Struct do
  defstruct request: %Ingress.Struct.Request{},
            private: %Ingress.Struct.Private{},
            response: %Ingress.Struct.Response{},
            debug: %Ingress.Struct.Debug{}
end
