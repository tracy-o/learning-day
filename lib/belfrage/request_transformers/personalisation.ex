defmodule Belfrage.RequestTransformers.Personalisation do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Authentication.SessionState

  @impl Transformer
  def call(envelope = %Envelope{private: %Envelope.Private{personalised_request: false}}) do
    {:ok, envelope}
  end

  def call(envelope = %Envelope{}) do
    session_state = SessionState.build(envelope.request)
    envelope = Envelope.add(envelope, :user_session, session_state)

    cond do
      return_401?(envelope) -> {:stop, Envelope.put_status(envelope, 401)}
      redirect?(envelope) -> redirect(envelope)
      true -> {:ok, envelope}
    end
  end

  defp return_401?(envelope) do
    reauthentication_required?(envelope.user_session) and envelope.request.app?
  end

  defp redirect?(envelope) do
    reauthentication_required?(envelope.user_session) and not envelope.request.app?
  end

  defp reauthentication_required?(session_state) do
    session_state.authenticated && !session_state.valid_session
  end

  defp redirect(envelope = %Envelope{}) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url(envelope.request),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "private"
        },
        body: "Redirecting"
      })
    }
  end

  defp session_url, do: Application.get_env(:belfrage, :authentication)["session_url"]

  defp redirect_url(request) do
    "#{session_url()}/session?ptrt=#{ptrt(request)}"
  end

  defp ptrt(request) do
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      request.host,
      request.path
    ])
    |> URI.encode_www_form()
    |> Kernel.<>(Belfrage.Helpers.QueryParams.encode(request.query_params, :encoded))
  end
end
