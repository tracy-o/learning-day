defmodule BelfrageWeb.StructAdapterTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.StructAdapter

  describe "BelfrageWeb.StructAdapter.adapt" do
    test "Adds www as the subdomain to the struct" do
      id = "12345678"
      conn = conn(:get, "https://www.belfrage.com/sport/videos/12345678")

      conn =
        put_private(conn, :bbc_headers, %{
          scheme: :https,
          host: "www.belfrage.com",
          country: "gb",
          replayed_traffic: false,
          varnish: 1,
          cache: 0
        })

      assert "www" == StructAdapter.adapt(conn, id).request.subdomain
    end

    test "When the subdomain is not www, it adds the subdomain of the host to the struct" do
      id = "12345678"
      conn = conn(:get, "https://test-branch.belfrage.com/_web_core")

      conn =
        put_private(conn, :bbc_headers, %{
          scheme: :https,
          host: "test-branch.belfrage.com",
          country: "gb",
          replayed_traffic: false,
          varnish: 1,
          cache: 0
        })

      assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
    end

    test "When the request contains a query string it is added to the struct" do
      id = "12345678"
      conn = conn(:get, "https://test-branch.belfrage.com/_web_core?foo=bar")

      conn =
        put_private(conn, :bbc_headers, %{
          scheme: :https,
          host: "test-branch.belfrage.com",
          country: "gb",
          query_string: %{foo: "ba"},
          replayed_traffic: false,
          varnish: 1,
          cache: 0
        })

      assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
    end

    test "When the request does not have a query string it adds an empty map to the struct" do
      id = "12345678"
      conn = conn(:get, "https://test-branch.belfrage.com/_web_core")

      conn =
        put_private(conn, :bbc_headers, %{
          scheme: :https,
          host: "test-branch.belfrage.com",
          country: "gb",
          query_string: %{},
          replayed_traffic: false,
          varnish: 1,
          cache: 0
        })

      assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
    end
  end
end
