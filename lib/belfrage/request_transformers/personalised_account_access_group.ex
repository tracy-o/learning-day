defmodule Belfrage.RequestTransformers.PersonalisedAccountAccessGroup do
  alias Belfrage.Authentication.BBCID
  use Belfrage.Behaviours.Transformer
  import Bitwise

  @impl Transformer
  def call(envelope = %{user_session: %{user_attributes: %{pseudonym: pseudonym}}}) do
    %{
      foryou_flagpole: foryou_flagpole,
      foryou_access_chance: foryou_access_chance,
      foryou_allowlist: foryou_allowlist
    } = BBCID.get_opts()

    if foryou_flagpole and valid_pseudonym?(pseudonym, foryou_allowlist, foryou_access_chance) do
      {:ok, envelope}
    else
      {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
    end
  end

  def call(envelope) do
    {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
  end

  defp valid_pseudonym?(pseudonym, foryou_allowlist, foryou_access_chance) do
    pseudonym in foryou_allowlist or generate_hash_value(pseudonym) <= foryou_access_chance
  end

  defp bit_mask(input), do: input &&& 0xFFFFFFFF

  def generate_hash_value(input) do
    input_grapheme = String.to_charlist(input)
    hash = 0

    List.foldl(input_grapheme, hash, fn char, acc ->
      ((acc <<< 5) - acc + char)
      |> bit_mask
      |> bor(0)
    end)
    |> rem(100)
    |> Kernel.+(1)
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
