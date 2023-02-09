defmodule Belfrage.Services.StubbedSession do
  require Logger
  alias Belfrage.Behaviours.Service
  @behaviour Service

  alias Belfrage.Envelope

  @impl Service
  def dispatch(envelope = %Envelope{}) do
    Logger.log(:debug, "", Map.from_struct(Envelope.loggable(envelope)))

    Envelope.add(envelope, :response, %Envelope.Response{
      http_status: 200,
      body: :zlib.gzip(response_body(envelope.user_session)),
      headers: %{
        "cache-control" => "private",
        "content-encoding" => "gzip",
        "content-type" => "application/json"
      }
    })
  end

  defp response_body(user_session = %Envelope.UserSession{}) do
    Jason.encode!(%{
      valid_session: user_session.valid_session,
      authenticated: user_session.authenticated,
      session_token: (user_session.session_token && "Provided") || nil
    })
  end
end
