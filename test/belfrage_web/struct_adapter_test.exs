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
          replayed_traffic: false
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
          replayed_traffic: false
        })

      assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
    end
  end
end
