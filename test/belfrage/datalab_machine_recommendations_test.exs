defmodule Belfrage.DatalabMachineRecommendationsTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper

  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}
  alias Belfrage.Clients.LambdaMock

  describe "dial is enabled" do
    setup do
      stub_dial(:datalab_machine_recommendations, "enabled")
      :ok
    end

    test "transformer is enabled for the route" do
      expect_origin_request(fn %{headers: headers} ->
        assert headers[:"ctx-features"] |> String.contains?("datalab_machine_recommendations=enabled")
      end)

      make_request("SportVideos")
    end

    test "transformer is not enabled for the route" do
      expect_origin_request(fn %{headers: headers} ->
        refute headers[:"ctx-features"] |> String.contains?("datalab_machine_recommendations=enabled")
      end)

      make_request("ProgrammesVideos")
    end
  end

  describe "dial is disabled" do
    setup do
      stub_dial(:datalab_machine_recommendations, "disabled")
      :ok
    end

    test "transformer is enabled for the route" do
      expect_origin_request(fn %{headers: headers} ->
        assert headers[:"ctx-features"] |> String.contains?("datalab_machine_recommendations=disabled")
      end)

      make_request("SportVideos")
    end

    test "transformer is not enabled for the route" do
      expect_origin_request(fn %{headers: headers} ->
        refute headers[:"ctx-features"] |> String.contains?("datalab_machine_recommendations=disabled")
      end)

      make_request("ProgrammesVideos")
    end
  end

  defp expect_origin_request(fun) do
    expect(LambdaMock, :call, fn _role_arn, _function_arn, request, _request_id, _opts ->
      fun.(request)

      {:ok,
       %{
         "headers" => %{
           "cache-control" => "private"
         },
         "statusCode" => 200,
         "body" => "OK"
       }}
    end)
  end

  defp make_request(spec) do
    Belfrage.handle(%Struct{
      private: %Private{
        loop_id: spec
      },
      request: %Request{
        path: "/_web_core",
        request_id: UUID.uuid4()
      }
    })
  end
end
