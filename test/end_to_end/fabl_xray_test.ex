defmodule EndToEndTest.FablTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.HTTP
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()
  end

  test "Fabl headers contain X-Amzn-Trace-Id" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %HTTP.Request{headers: headers}, :fabl ->
      assert Map.has_key?(headers, "X-Amzn-Trace-Id")
      assert String.contains?(headers["X-Amzn-Trace-Id"], "Sampled=")
      assert String.contains?(headers["X-Amzn-Trace-Id"], "Root=")
      assert String.contains?(headers["X-Amzn-Trace-Id"], "Parent=")

      {:ok,
       %HTTP.Response{
         headers: %{"cache-control" => "public, max-age=60"},
         status_code: 200,
         body: ""
       }}
    end)

    conn = conn(:get, "/fabl/xray") |> Router.call([])

    {200, _, _} = sent_resp(conn)
  end
end
