defmodule EndToEndTest.FormatRewriterTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.RouteState

  @moduletag :end_to_end

  describe "when path does not have a trailing format" do
    setup do
      start_supervised!({RouteState, "SomeRouteState"})

      Belfrage.Clients.LambdaMock
      |> stub(:call, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
        {:ok,
         %{
           "headers" => %{
             "cache-control" => "public, max-age=30"
           },
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      :ok
    end

    test "router handles literal segment" do
      resp_conn = conn(:get, "/200-ok-response") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["200-ok-response"] == resp_conn.path_info
      assert %{} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/200-ok-response")
    end

    test "router handles identifier segment" do
      # /format/rewrite/:discipline route
      resp_conn = conn(:get, "/format/rewrite/cricket") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "cricket"] == resp_conn.path_info
      assert %{"discipline" => "cricket"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline")
    end

    test "router handles identifier segment in the middle of path" do
      # /format/rewrite/:discipline/av route
      resp_conn = conn(:get, "/format/rewrite/cricket/av") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "cricket", "av"] == resp_conn.path_info
      assert %{"discipline" => "cricket"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline/av")
    end

    test "router handles multiple identifier segments" do
      # /format/rewrite/:discipline/av/:team route
      resp_conn = conn(:get, "/format/rewrite/cricket/av/india") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "cricket", "av", "india"] == resp_conn.path_info
      assert %{"discipline" => "cricket", "team" => "india"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/*_path/format/rewrite/:discipline/av/:team")
    end
  end

  describe "when path has a trailing format" do
    setup do
      start_supervised!({RouteState, "SomeMozartRouteState"})

      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn _, :MozartNews ->
        {:ok,
         %Belfrage.Clients.HTTP.Response{
           status_code: 200,
           body: "some stuff from mozart",
           headers: %{}
         }}
      end)

      :ok
    end

    test "router handles identifier segment" do
      # /format/rewrite/:discipline.app route
      resp_conn = conn(:get, "/format/rewrite/cricket.app") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "cricket", ".app"] == resp_conn.path_info
      assert %{"discipline" => "cricket", "format" => "app"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline/.app")
    end

    test "router handles multiple identifier segments" do
      # /format/rewrite/:discipline/av/:team.app route
      resp_conn = conn(:get, "/format/rewrite/cricket/av/india.app") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "cricket", "av", "india", ".app"] == resp_conn.path_info
      assert %{"discipline" => "cricket", "format" => "app", "team" => "india"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline/av/:team/.app")
    end
  end

  describe "when path has multiple formats" do
    setup do
      start_supervised!({RouteState, "SomeMozartRouteState"})

      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn _, :MozartNews ->
        {:ok,
         %Belfrage.Clients.HTTP.Response{
           status_code: 200,
           body: "some stuff from mozart",
           headers: %{}
         }}
      end)

      :ok
    end

    test "router handles identifier segment" do
      # /format/rewrite/:discipline.app route
      resp_conn = conn(:get, "/format/rewrite/athletics.200m.app") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "athletics.200m", ".app"] == resp_conn.path_info
      assert %{"discipline" => "athletics.200m", "format" => "app"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline/.app")
    end

    test "router handles multiple identifier segments" do
      # /format/rewrite/:discipline/av/:team.app route
      resp_conn = conn(:get, "/format/rewrite/athletics.200m/av/india.delhi.app") |> Router.call([])
      {matched_route, _matched_fun} = resp_conn.private.plug_route

      assert ["format", "rewrite", "athletics.200m", "av", "india.delhi", ".app"] == resp_conn.path_info
      assert %{"discipline" => "athletics.200m", "format" => "app", "team" => "india.delhi"} == resp_conn.path_params
      assert String.ends_with?(matched_route, "/format/rewrite/:discipline/av/:team/.app")
    end
  end
end
