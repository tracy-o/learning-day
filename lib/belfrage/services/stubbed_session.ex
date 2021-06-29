defmodule Belfrage.Services.StubbedSession do
  alias Belfrage.Behaviours.Service
  @behaviour Service

  alias Belfrage.Struct

  @impl Service
  def dispatch(struct = %Struct{}) do
    Belfrage.Event.record(:log, :debug, Struct.loggable(struct))

    Struct.add(struct, :response, %Struct.Response{
      http_status: 200,
      body: :zlib.gzip(response_body(struct.user_session)),
      headers: %{
        "cache-control" => "private",
        "content-encoding" => "gzip",
        "content-type" => "application/json"
      }
    })
  end

  defp response_body(user_session = %Struct.UserSession{}) do
    Jason.encode!(%{
      valid_session: user_session.valid_session,
      authenticated: user_session.authenticated,
      session_token: (user_session.session_token && "Provided") || nil
    })
  end
end
