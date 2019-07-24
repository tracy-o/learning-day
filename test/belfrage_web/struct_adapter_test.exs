defmodule BelfrageWeb.StructAdapterTest do
  use ExUnit.Case
  use Plug.Test

  alias Belfrage.Struct
  alias BelfrageWeb.StructAdapter

  describe "BelfrageWeb.StructAdapter.adapt" do
    test "Adds www as the subdomain to the struct" do
      conn = conn(:get, "https://www.belfrage.com/_web_core")
      conn = put_private(conn, :bbc_headers, %{country: "gb", replayed_traffic: false})

      assert "www" == BelfrageWeb.StructAdapter.adapt(conn).private.subdomain
    end

    test "When the subdomain is not www, it adds the subdomain of the host to the struct" do
      conn = conn(:get, "https://test-branch.belfrage.com/_web_core")
      conn = put_private(conn, :bbc_headers, %{country: "gb", replayed_traffic: false})

      assert "test-branch" == BelfrageWeb.StructAdapter.adapt(conn).private.subdomain
    end
  end
end
