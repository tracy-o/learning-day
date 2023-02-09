defmodule Belfrage.RequestHash do
  alias Belfrage.{Envelope, Mvt}
  alias Belfrage.Envelope.Private

  @signature_keys [
    :raw_headers,
    :query_params,
    :country,
    :has_been_replayed?,
    :origin_simulator?,
    :host,
    :is_uk,
    :method,
    :path,
    :scheme,
    :cdn?
  ]

  @ignore_headers ~w(cookie x-id-oidc-signedin)

  def put(envelope = %Envelope{}) do
    Envelope.add(envelope, :request, %{request_hash: generate(envelope)})
  end

  def generate(envelope = %Envelope{}) do
    if Belfrage.Overrides.should_cache_bust?(envelope) do
      cache_bust_hash()
    else
      envelope
      |> take_signature_keys()
      |> Crimpex.signature()
    end
  end

  defp cache_bust_hash() do
    "cache-bust." <> UUID.uuid4()
  end

  defp take_signature_keys(envelope = %Envelope{}) do
    envelope.request
    |> Map.take(signature_keys(envelope.private))
    |> filter_headers(envelope.private.route_state_id)
  end

  defp signature_keys(%Private{signature_keys: %{add: add, skip: skip}}) do
    (@signature_keys ++ add) -- skip
  end

  defp filter_headers(keys, route_state_id) do
    case keys do
      %{raw_headers: headers} when headers != %{} ->
        %{keys | raw_headers: signature_headers(headers, route_state_id)}

      _ ->
        keys
    end
  end

  defp signature_headers(headers, route_state_id) do
    headers
    |> Mvt.State.filter_headers(route_state_id)
    |> Map.drop(@ignore_headers)
  end
end
