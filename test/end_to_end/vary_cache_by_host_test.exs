defmodule VaryCacheByHost do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()

    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    %{
      no_host_header: conn(:get, "/200-ok-response") |> Map.put(:host, "belfrage.com"),
      no_host_header_on_preview: conn(:get, "/200-ok-response") |> Map.put(:host, "preview.com"),
      edge_host: conn(:get, "/200-ok-response") |> put_req_header("x-forwarded-host", "forwarded.com"),
      forwarded_host: conn(:get, "/200-ok-response") |> put_req_header("host", "host.com")
    }
  end

  test "different hosts produce different request hashes", conns do
    [no_host_header_bsig] = conns.no_host_header |> Router.call([]) |> get_resp_header("bsig")
    [no_host_header_on_preview_bsig] = conns.no_host_header_on_preview |> Router.call([]) |> get_resp_header("bsig")

    [edge_host_bsig] = conns.edge_host |> Router.call([]) |> get_resp_header("bsig")
    [forwarded_host_bsig] = conns.forwarded_host |> Router.call([]) |> get_resp_header("bsig")

    signatures = [no_host_header_bsig, no_host_header_on_preview_bsig, edge_host_bsig, forwarded_host_bsig]
    assert signatures == signatures |> Enum.uniq()
  end
end
