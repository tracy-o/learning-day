defmodule Belfrage.RequestTransformers.PersonalisedAccountProfilesRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %{user_session: %{user_attributes: %{profile_admin_id: _profile_admin_id}}}) do
    {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
  end

  def call(envelope) do
    {:ok, envelope}
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
