defmodule EndToEnd.ClassicAppFablLdpTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}
  use Test.Support.Helper, :mox

  describe "request is made to FABL" do
    setup do
      :ets.delete_all_objects(:cache)
      {:ok, %{subject_id: "cd988a73-6c41-4690-b785-c8d3abc2d13c", created_by: "something", language: "en"}}
    end

    test "with correct query and path params", %{subject_id: subject_id, language: language, created_by: created_by} do
      fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

      url =
        "#{fabl_endpoint}/module/abl-classic?createdBy=#{created_by}&foo=bar&language=#{language}&subjectId=#{subject_id}"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 200,
           body: "OK"
         }}
      end)

      conn(
        :get,
        "https://news-app-classic.test.api.bbci.co.uk/content/ldp/#{subject_id}?language=#{language}&createdBy=#{created_by}&foo=bar"
      )
      |> Router.call(routefile: Routes.Routefiles.Mock)
    end

    test ~s(with cache-control header values from origin response, with "stale-" values added), %{
      subject_id: subject_id,
      language: language,
      created_by: created_by
    } do
      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: _url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{"cache-control" => "public, max-age=5"},
           status_code: 200,
           body: "OK"
         }}
      end)

      conn =
        conn(
          :get,
          "https://news-app-classic.test.api.bbci.co.uk/content/ldp/#{subject_id}?language=#{language}&createdBy=#{created_by}&foo=bar"
        )
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=60"] ==
               get_resp_header(conn, "cache-control")
    end
  end
end
