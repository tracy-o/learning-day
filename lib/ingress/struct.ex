# An attempt to start defining the struct called Struct

defmodule Ingress.Struct.Request do
  @enforce_keys [:path]
  defstruct [:path, :payload]
end

defmodule Ingress.Struct.Response do
  @enforce_keys [:http_status, :headers, :body]
  defstruct [:http_status, :headers, :body]
end

defmodule Ingress.Struct.Private do
  defstruct [:loop_id]
end

defmodule Ingress.Struct do
  defstruct request: Ingress.Struct.Request,
            private: Ingress.Struct.Private,
            response: Ingress.Struct.Response
end
