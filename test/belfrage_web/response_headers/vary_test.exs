defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Belfrage.Struct

  @with_cache %Struct{request: %Struct.Request{edge_cache?: true}}
  @no_cache %Struct{request: %Struct.Request{edge_cache?: false}}
  @with_cdn %Struct{request: %Struct.Request{cdn?: true}}

  doctest Vary

  describe "Country Header" do
    test "When the request is from varnish and the cache header is set it varies on X-BBC-Edge-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, X-BBC-Edge-IsUK, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the request is from varnish and the cache header isnt set it varies on X-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @no_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, X-IP_Is_UK_Combined, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the cache header is set it varies on X-BBC-Edge-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, X-BBC-Edge-IsUK, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the request is not from varnish and the cache header isnt set it doesnt vary on a country header" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @no_cache)

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, X-IP_Is_UK_Combined, X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end
  end

  describe "Reduced Vary Header - when serving through CDN" do
    test "When the request is from a CDN it only varies on Accept-Encoding" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_cdn)

      assert ["Accept-Encoding"] ==
               get_resp_header(output_conn, "vary")
    end
  end

  describe "is_uk" do
    test "when the request is from the edge then it varies on x-bbc-edge-isuk" do
      conn =
        conn(:get, "/page")
        |> Vary.add_header(%Struct{request: %Struct.Request{edge_cache?: true}})

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country, X-BBC-Edge-IsUK, X-BBC-Edge-Scheme"] ==
               get_resp_header(conn, "vary")
    end

    test "when the request is not from the edge then it varies on x-ip_is_uk_combined" do
      conn =
        conn(:get, "/page")
        |> Vary.add_header(%Struct{request: %Struct.Request{edge_cache?: false}})

      assert ["Accept-Encoding, X-BBC-Edge-Cache, X-Country, X-IP_Is_UK_Combined, X-BBC-Edge-Scheme"] ==
               get_resp_header(conn, "vary")
    end
  end

  describe "raw_headers" do
    test "varies on provided raw headers, when cdn is false" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{request: %Struct.Request{raw_headers: %{"one" => "header", "another" => "header 2"}}})

      assert List.first(get_resp_header(conn, "vary")) =~ ", another, one"
    end

    test "does not vary on provided raw headers, when cdn is true" do
      input_conn = conn(:get, "/")
      struct = @with_cdn |> Struct.add(:request, %{raw_headers: %{"one" => "header", "another" => "header 2"}})
      output_conn = Vary.add_header(input_conn, struct)

      refute List.first(get_resp_header(output_conn, "vary")) =~ ", another, one"
    end
  end
end
