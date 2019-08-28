defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Test.Support.StructHelper

  @non_varnish_with_cache StructHelper.build(request: %{varnish?: false, cache?: true})
  @with_varnish_no_cache StructHelper.build(request: %{varnish?: true, cache?: false})
  @no_varnish_or_cache StructHelper.build(request: %{varnish?: false, cache?: false})

  doctest Vary

  test "When the request is not from varnish and the cache header is set it varies on X-BBC-Edge-Country" do
    input_conn = conn(:get, "/sport")
    output_conn = Vary.add_header(input_conn, @non_varnish_with_cache)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end

  test "When the request is from varnish and the cache header isnt set it varies on X-Country" do
    input_conn = conn(:get, "/sport")
    output_conn = Vary.add_header(input_conn, @with_varnish_no_cache)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end

  test "When the request is not from varnish and the cache header isnt set it doesnt vary on a country header" do
    input_conn = conn(:get, "/sport")
    output_conn = Vary.add_header(input_conn, @no_varnish_or_cache)

    assert ["Accept-Encoding, X-BBC-Edge-Cache, Replayed-Traffic, X-BBC-Edge-Scheme"] ==
             get_resp_header(output_conn, "vary")
  end
end
