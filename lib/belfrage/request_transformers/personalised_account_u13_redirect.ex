defmodule Belfrage.RequestTransformers.PersonalisedAccountU13Redirect do
  use Belfrage.Behaviours.Transformer
  require Logger

  @impl Transformer
  def call(envelope) do
    case envelope.user_session do
      %{user_attributes: %{age_bracket: bracket}} when bracket not in ["u13", nil] -> {:ok, envelope}
      _ -> {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
    end
  end

  defp make_redirect_resp(envelope) do
    %{
      http_status: 302,
      headers: %{
        "location" => redirect_url(envelope.request),
        "x-bbc-no-scheme-rewrite" => "1",
        "cache-control" => "private, max-age=0"
      },
      body: ""
    }
  end

  defp redirect_url(request) do
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      request.host,
      "/account"
    ])
  end
end
