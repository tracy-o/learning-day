defmodule Belfrage.Allowlist.Cookies do
  alias Belfrage.Envelope
  alias Envelope.Private

  import Plug.Conn.Cookies, only: [decode: 1]

  def filter(
        envelope = %Envelope{
          request: %Envelope.Request{raw_headers: %{"cookie" => cookie}},
          private: %Private{cookie_allowlist: allowlist}
        }
      ) do
    Envelope.add(envelope, :request, %{cookies: take_cookies(decode(cookie), allowlist)})
  end

  def filter(envelope), do: envelope

  defp take_cookies(all_cookies, "*"), do: all_cookies

  defp take_cookies(all_cookies, allowlist) do
    Map.take(all_cookies, allowlist)
  end
end
