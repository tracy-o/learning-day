defmodule Belfrage.Allowlist.Cookies do
  alias Belfrage.Struct
  alias Struct.Private

  import Plug.Conn.Cookies, only: [decode: 1]

  def filter(
        struct = %Struct{
          request: %Struct.Request{raw_headers: %{"cookie" => cookie}},
          private: %Private{cookie_allowlist: allowlist}
        }
      ) do
    Struct.add(struct, :request, %{cookies: take_cookies(decode(cookie), allowlist)})
  end

  def filter(struct), do: struct

  defp take_cookies(all_cookies, "*"), do: all_cookies

  defp take_cookies(all_cookies, allowlist) do
    Map.take(all_cookies, allowlist)
  end
end
