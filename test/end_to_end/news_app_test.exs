defmodule EndToEnd.NewsAppsTest do
  use ExUnit.Case, async: false
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  alias Belfrage.Utils.Current

  describe "when the NewsAppsHardcodedResponse dial is enabled" do
    test "returns a hardcoded payload" do
      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn = conn(:get, "/fd/abl") |> Router.call([])

      {200, _resp_headers, body} = sent_resp(response_conn)
      assert body =~ "CallToActionBanner"
    end

    test "returns the same etag when requests are within the same hour" do
      Current.Mock.freeze(~D[2022-12-02], ~T[11:14:52.368815Z])

      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn1 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, _body} = sent_resp(response_conn1)
      [etag1] = get_resp_header(response_conn1, "etag")

      assert etag1 == "\"6c65c87901c36aa9afc266d70bf6539d2a283198\""

      # 20 mins later...
      Current.Mock.freeze(~D[2022-12-02], ~T[11:34:56.368815Z])

      response_conn2 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, _body} = sent_resp(response_conn2)
      [etag2] = get_resp_header(response_conn2, "etag")

      assert etag1 == etag2
      on_exit(&Current.Mock.unfreeze/0)
    end

    test "returns a different etag when requests are over two different hours" do
      Current.Mock.freeze(~D[2022-12-02], ~T[11:58:52.368815Z])

      stub_dials(news_apps_hardcoded_response: "enabled")

      response_conn1 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, _body} = sent_resp(response_conn1)
      [etag1] = get_resp_header(response_conn1, "etag")

      assert etag1 == "\"6c65c87901c36aa9afc266d70bf6539d2a283198\""

      Current.Mock.freeze(~D[2022-12-02], ~T[12:01:16.368815Z])

      response_conn2 = conn(:get, "/fd/abl") |> Router.call([])
      {200, _resp_headers, _body} = sent_resp(response_conn2)
      [etag2] = get_resp_header(response_conn2, "etag")

      assert etag1 != etag2
      on_exit(&Current.Mock.unfreeze/0)
    end
  end

  describe "when the NewsAppsHardcodedResponse dial is disabled" do
    test "does not return an hardcoded payload" do
      stub_dials(news_apps_hardcoded_response: "disabled")

      response_conn = conn(:get, "/fd/abl") |> Router.call([])

      {200, _resp_headers, body} = sent_resp(response_conn)
      assert body =~ "Echo Response"
    end
  end
end
