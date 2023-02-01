defmodule AllowHeadersTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.{RouteState, RouteSpecManager}
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [set_env: 4]

  @ok_response %Belfrage.Clients.HTTP.Response{
    status_code: 200,
    body: "some stuff from mozart",
    headers: %{}
  }

  @not_found_response %Belfrage.Clients.HTTP.Response{status_code: 404}

  setup do
    mock_http_response()
    :ets.delete_all_objects(:cache)
    :ok
  end

  test "Allow 'ctx-service-env' header for Fabl platform on test" do
    RouteSpecManager.update_specs()
    start_supervised!({RouteState, "FablData.Fabl"})
    assert {200, _headers, _body} = sent_resp(get_fabldata_conn_with_header())
  end

  test "Don't allow 'ctx-service-env' header for Fabl platform on live" do
    set_env(:belfrage, :production_environment, "live", &RouteSpecManager.update_specs/0)
    RouteSpecManager.update_specs()
    start_supervised!({RouteState, "FablData.Fabl"})
    assert {404, _headers, _body} = sent_resp(get_fabldata_conn_with_header())
  end

  defp get_fabldata_conn_with_header() do
    conn(:get, "/app-request/some_name")
    |> put_req_header("ctx-service-env", "test")
    |> Router.call([])
  end

  defp mock_http_response() do
    url = Application.get_env(:belfrage, :fabl_endpoint) <> "/module/some_name"

    mock_fun = fn %Belfrage.Clients.HTTP.Request{method: :get, url: ^url, headers: headers}, :Fabl ->
      case Map.get(headers, "ctx-service-env") do
        nil -> {:ok, @not_found_response}
        "test" -> {:ok, @ok_response}
      end
    end

    Belfrage.Clients.HTTPMock |> expect(:execute, mock_fun)
  end
end
