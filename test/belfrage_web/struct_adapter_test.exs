defmodule BelfrageWeb.StructAdapterTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.StructAdapter

  defp put_test_production_environment(conn) do
    put_private(conn, :production_environment, "test")
  end

  test "Adds www as the subdomain to the struct" do
    id = "12345678"

    conn =
      conn(:get, "https://www.belfrage.com/sport/videos/12345678")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "www.belfrage.com",
        country: "gb",
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "www" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "When the subdomain is not www, it adds the subdomain of the host to the struct" do
    id = "12345678"

    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "test-branch.belfrage.com",
        country: "gb",
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "when the host header is empty, we default to www" do
    id = "12345678"

    conn =
      conn(:get, "https://www.belfrage.com/_web_core")
      |> Map.put(:host, "")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "www",
        country: "gb",
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "www" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "when the host header is not binary, we default to www" do
    id = "12345678"

    conn =
      conn(:get, "https://www.belfrage.com/_web_core")
      |> Map.put(:host, nil)
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "www",
        country: "gb",
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "www" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "When the request contains a query string it is added to the struct" do
    id = "12345678"

    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core?foo=bar")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "test-branch.belfrage.com",
        country: "gb",
        query_string: %{foo: "ba"},
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "When the request does not have a query string it adds an empty map to the struct" do
    id = "12345678"

    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "test-branch.belfrage.com",
        country: "gb",
        query_string: %{},
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "test-branch" == StructAdapter.adapt(conn, id).request.subdomain
  end

  test "when the path has path parameters" do
    id = "12345678"

    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core/article-1234")
      |> Map.put(:path_params, %{"id" => "article-1234"})
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "test-branch.belfrage.com",
        country: "gb",
        query_string: %{},
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert %{"id" => "article-1234"} == StructAdapter.adapt(conn, id).request.path_params
  end

  test "Adds the production_environment to the struct" do
    id = "12345678"

    conn =
      conn(:get, "https://www.belfrage.com/sport/videos/12345678")
      |> put_test_production_environment()
      |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
      |> put_private(:bbc_headers, %{
        scheme: :https,
        host: "www.belfrage.com",
        country: "gb",
        replayed_traffic: nil,
        varnish: 1,
        cache: 0
      })
      |> put_private(:overrides, %{})

    assert "test" == StructAdapter.adapt(conn, id).private.production_environment
  end

  describe "accept_encoding value" do
    test "when an Accept-Encoding header is provided" do
      id = "12345678"

      conn =
        conn(:get, "/")
        |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
        |> put_private(:overrides, %{})
        |> put_test_production_environment()
        |> put_private(:bbc_headers, %{
          scheme: :https,
          host: "www.belfrage.com",
          country: "gb",
          replayed_traffic: nil,
          varnish: 1,
          cache: 0
        })
        |> put_req_header("accept-encoding", "gzip, deflate, br")

      assert "gzip, deflate, br" == StructAdapter.adapt(conn, id).request.accept_encoding
    end

    test "when an Accept-Encoding header is not provided" do
      id = "12345678"

      conn =
        conn(:get, "/")
        |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
        |> put_private(:overrides, %{})
        |> put_test_production_environment()
        |> put_private(:bbc_headers, %{
          scheme: :https,
          host: "www.belfrage.com",
          country: "gb",
          replayed_traffic: nil,
          varnish: 1,
          cache: 0
        })

      assert nil == StructAdapter.adapt(conn, id).request.accept_encoding
    end
  end
end
