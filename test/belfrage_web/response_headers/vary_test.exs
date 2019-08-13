defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary

  doctest Vary

  test "Adding vary returns conn with vary header added" do
    input_conn = conn(:get, "/_web_core")
    output_conn = Vary.add_header(input_conn, nil)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end
end
