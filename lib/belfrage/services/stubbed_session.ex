defmodule Belfrage.Services.StubbedSession do
  alias Belfrage.Behaviours.Service
  @behaviour Service

  alias Belfrage.Struct

  @impl Service
  def dispatch(struct = %Struct{}) do
    Struct.add(struct, :response, %Struct.Response{
      http_status: 200,
      body: :zlib.gzip(response_body(struct.private)),
      headers: %{
        "cache-control" => "private",
        "content-encoding" => "gzip",
        "content-type" => "application/json"
      }
    })
  end

  defp response_body(private = %Struct.Private{}) do
    Jason.encode!(%{
      valid_session: private.valid_session,
      authenticated: private.authenticated,
      session_token: (private.session_token && "Provided") || nil
    })
  end
end
