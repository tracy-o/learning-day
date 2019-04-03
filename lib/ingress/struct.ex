defmodule Ingress.Struct do
  defstruct request: Ingress.Struct.Request,
            private: Ingress.Struct.Private,
            response: Ingress.Struct.Response,
            debug: Ingress.Struct.Debug
end

defmodule Ingress.Struct.Debug do
  defstruct [:pipeline_trail]
end

defmodule Ingress.Struct.Request do
  @enforce_keys [:path]
  defstruct [:path, :payload]
end

defmodule Ingress.Struct.Response do
  @enforce_keys [:http_status, :headers, :body]
  defstruct [:http_status, :headers, :body]
end

defmodule Ingress.Struct.Private do
  @enforce_keys [:loop_id]
  defstruct [:loop_id, :origin, :pipeline, :counter]

  def put_loop(struct = %Ingress.Struct{private: %Ingress.Struct.Private{}}, loop) do
    struct
    |> Map.put(:private, Map.merge(struct.private, loop))
  end
end
