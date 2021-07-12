defmodule BelfrageWeb.ResponseHeaders.VaryTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Belfrage.Struct

  @with_cache %Struct{request: %Struct.Request{edge_cache?: true}}
  @no_cache %Struct{request: %Struct.Request{edge_cache?: false}}
  @with_cdn %Struct{request: %Struct.Request{cdn?: true}}

  doctest Vary

  describe "Country Header" do
    test "When the cache header is set it varies on X-BBC-Edge-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @with_cache)

      assert ["Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"] ==
               get_resp_header(output_conn, "vary")
    end

    test "When the cache header isnt set it varies on X-Country" do
      input_conn = conn(:get, "/sport")
      output_conn = Vary.add_header(input_conn, @no_cache)

      assert ["Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"] ==
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

      assert ["Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"] ==
               get_resp_header(conn, "vary")
    end

    test "when the request is not from the edge then it varies on x-ip_is_uk_combined" do
      conn =
        conn(:get, "/page")
        |> Vary.add_header(%Struct{request: %Struct.Request{edge_cache?: false}})

      assert ["Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"] ==
               get_resp_header(conn, "vary")
    end
  end

  describe "allowed_headers" do
    test "varies on a provided allowed header, when cdn is false" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{private: %Struct.Private{headers_allowlist: ["one_header"]}})

      assert List.first(get_resp_header(conn, "vary")) =~ ",one_header"
    end

    test "varies on provided allowed headers, when cdn is false" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          private: %Struct.Private{headers_allowlist: ["one_header", "another_header", "more_header"]}
        })

      assert List.first(get_resp_header(conn, "vary")) =~ ",one_header,another_header,more_header"
    end

    test "does not vary on allowed headers, when cdn is true" do
      input_conn = conn(:get, "/")
      struct = @with_cdn |> Struct.add(:private, %{headers_allowlist: ["one_header", "another_header"]})
      output_conn = Vary.add_header(input_conn, struct)

      refute List.first(get_resp_header(output_conn, "vary")) =~ ",one_header,another_header"
    end

    test "never vary on cookie" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          private: %Struct.Private{headers_allowlist: ["cookie"]}
        })

      refute List.first(get_resp_header(conn, "vary")) =~ ",cookie"
    end
  end

  describe "advertise headers" do
    test "varies on X-Ip_is_advertise_combined when platform is Simorgh and request not edge cache" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          request: %Struct.Request{edge_cache?: false},
          private: %Struct.Private{platform: Simorgh}
        })

      assert List.first(get_resp_header(conn, "vary")) =~ ",X-Ip_is_advertise_combined"
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Simorgh and request edge cache" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          request: %Struct.Request{edge_cache?: true},
          private: %Struct.Private{platform: Simorgh}
        })

      refute List.first(get_resp_header(conn, "vary")) =~ ",X-Ip_is_advertise_combined"
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request not edge cache" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          request: %Struct.Request{edge_cache?: false},
          private: %Struct.Private{platform: WebCore}
        })

      refute List.first(get_resp_header(conn, "vary")) =~ ",X-Ip_is_advertise_combined"
    end

    test "does not vary on X-Ip_is_advertise_combined when platform is Webcore and request edge cache" do
      conn =
        conn(:get, "/")
        |> Vary.add_header(%Struct{
          request: %Struct.Request{edge_cache?: true},
          private: %Struct.Private{platform: WebCore}
        })

      refute List.first(get_resp_header(conn, "vary")) =~ ",X-Ip_is_advertise_combined"
    end
  end
end
