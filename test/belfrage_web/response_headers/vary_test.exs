defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Belfrage.Struct

  @with_varnish_and_cache %Struct{request: %Struct.Request{varnish?: true, edge_cache?: true}}
  @non_varnish_with_cache %Struct{request: %Struct.Request{varnish?: false, edge_cache?: true}}
  @with_varnish_no_cache %Struct{request: %Struct.Request{varnish?: true, edge_cache?: false}}
  @no_varnish_or_cache %Struct{request: %Struct.Request{varnish?: false, edge_cache?: false}}

  doctest Vary

  describe "Country Header" do
    test "When the request is from varnish and the cache header is set it varies on X-BBC-Edge-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_varnish_and_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the request is from varnish and the cache header isnt set it varies on X-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_varnish_no_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the cache header is set it varies on X-BBC-Edge-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @non_varnish_with_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the request is not from varnish and the cache header isnt set it doesnt vary on a country header" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @no_varnish_or_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end
  end
end
