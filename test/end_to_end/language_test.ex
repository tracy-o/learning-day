defmodule EndToEnd.LanguageTest do
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

  defp expect_lambda_call(opts \\ []) do
    times_called = Keyword.get(opts, :times_called, 1)
    headers = Keyword.get(opts, :headers, %{})

    # this if statment is to get rid of compiler warnings
    if headers == %{} do
      Belfrage.Clients.LambdaMock
      |> expect(:call, times_called, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
        {:ok, @lambda_response}
      end)
    else
      Belfrage.Clients.LambdaMock
      |> expect(:call, times_called, fn _lambda_name, _role_arn, headers, _request_id, _opts ->
        {:ok, @lambda_response}
      end)
    end
  end

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()
  end

  describe "when language_from_cookie false" do
    test "the request_hash doesn't vary on cookie-ckps_language" do
      expect_lambda_call(times_called: 2)

      conn_ga =
        conn(:get, "/200-ok-response")
        |> put_req_header("cookie-ckps_language", "ga")
        |> Router.call([])

      :ets.delete_all_objects(:cache)

      conn_cy =
        conn(:get, "/200-ok-response")
        |> put_req_header("cookie-ckps_language", "cy")
        |> Router.call([])

      assert get_resp_header(conn_ga, "bsig") == get_resp_header(conn_cy, "bsig")
    end

    test "the langauge header uses the default language" do
      expect_lambda_call(headers: %{language: "en-GB"})

      conn(:get, "/200-ok-response")
      |> put_req_header("cookie-ckps_language", "ga")
      |> Router.call([])
    end

    test "the vary header doesn't contain cookie-ckps_language" do
      expect_lambda_call()

      vary_string =
        conn(:get, "/200-ok-response")
        |> put_req_header("cookie-ckps_language", "ga")
        |> Router.call([])
        |> get_resp_header("vary")
        |> (fn [vary_string] -> vary_string end).()

      refute vary_string =~ "cookie-ckps_language"
    end
  end

  describe "when language_from_cookie true" do
    test "the request_hash varys on cookie-ckps_language" do
      expect_lambda_call(times_called: 2)

      conn_ga =
        conn(:get, "/language-from-cookie")
        |> put_req_header("cookie-ckps_language", "ga")
        |> Router.call([])

      conn_cy =
        conn(:get, "/language-from-cookie")
        |> put_req_header("cookie-ckps_language", "cy")
        |> Router.call([])

      assert get_resp_header(conn_ga, "bsig") != get_resp_header(conn_cy, "bsig")
    end

    test "the language header contains the value from the cookie" do
      expect_lambda_call(headers: %{language: "ga"})

      conn(:get, "/language-from-cookie")
      |> put_req_header("cookie-ckps_language", "ga")
      |> Router.call([])
    end

    test "the vary header contains cookie-ckps_language" do
      expect_lambda_call()

      [vary_string] =
        conn(:get, "/language-from-cookie")
        |> put_req_header("cookie-ckps_language", "ga")
        |> Router.call([])
        |> get_resp_header("vary")

      assert vary_string =~ "cookie-ckps_language"
    end
  end
end
