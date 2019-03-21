# An attempt to start defining the struct called Struct

defmodule Ingress.Struct.Request do
  defstruct [:request_id, :format]
end

defmodule Ingress.Struct.Response do
  defstruct [:http_status, :headers, :body]
end

defmodule Ingress.Struct.Private do
  defstruct [:req_pipelines, :res_pipelines]
end

defmodule Ingress.Struct do
  defstruct request: %Ingress.Struct.Request{},
            private: %Ingress.Struct.Private{},
            response: %Ingress.Struct.Response{}
end
