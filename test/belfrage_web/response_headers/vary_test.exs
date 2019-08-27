defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Test.Support.StructHelper

  @non_varnish StructHelper.build(request: %{varnish?: nil})
  @varnish_true StructHelper.build(request: %{varnish?: true})

  doctest Vary

  test "Adding vary returns conn with vary header added" do
    input_conn = conn(:get, "/_web_core")
    output_conn = Vary.add_header(input_conn, @non_varnish)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end

  test "When the request is not from varnish it varies on X-Country not X-BBC-Edge-Country" do
    input_conn = conn(:get, "/_web_core")
    output_conn = Vary.add_header(input_conn, @varnish_true)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end
end
