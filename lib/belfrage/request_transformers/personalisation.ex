defmodule Belfrage.RequestTransformers.Personalisation do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Authentication.SessionState

  @impl Transformer
  def call(struct = %Struct{private: %Struct.Private{personalised_request: false}}) do
    {:ok, struct}
  end

  def call(struct = %Struct{}) do
    session_state = SessionState.build(struct.request)
    struct = Struct.add(struct, :user_session, session_state)

    cond do
      return_401?(struct) -> {:stop, Struct.put_status(struct, 401)}
      redirect?(struct) -> redirect(struct)
      true -> {:ok, struct}
    end
  end

  defp return_401?(struct) do
    reauthentication_required?(struct.user_session) and struct.request.app?
  end

  defp redirect?(struct) do
    reauthentication_required?(struct.user_session) and not struct.request.app?
  end

  defp reauthentication_required?(session_state) do
    session_state.authenticated && !session_state.valid_session
  end

  defp redirect(struct = %Struct{}) do
    {
      :stop,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url(struct.request),
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
