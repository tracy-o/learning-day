defmodule Belfrage.Services.CascadeTest do
  alias Belfrage.Clients
  alias Belfrage.Services.Cascade
  alias Belfrage.Struct

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @arn Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)

  @http_struct %Struct{
    private: %Struct.Private{
      origin: "https://www.bbc.co.uk",
      platform: MozartNews
    },
    request: %Struct.Request{
      method: "GET",
      path: "/_some_path",
      request_id: "henry-the-http-request"
    }
  }

  @fabl_struct %Struct{
    private: %Struct.Private{
      origin: "https://fabl.test.api.bbci.co.uk",
      platform: Fabl
    },
    request: %Struct.Request{
      method: "GET",
      path: "/fd/example-module",
      path_params: %{
        "name" => "example-module"
      },
      request_id: "frank-the-fabl-request"
    }
  }

  @webcore_struct %Struct{
    private: %Struct.Private{origin: "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function", platform: Webcore},
    request: %Struct.Request{
      method: "GET",
      path: "/_web_core",
      request_id: "will-the-webcore-request"
    }
  }

  def mock_http_with(status_code) do
    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Belfrage.Clients.HTTP.Request{
           method: :get,
           url: "https://www.bbc.co.uk/_some_path"
         },
         :MozartNews ->
        {:ok,
         %Belfrage.Clients.HTTP.Response{
           status_code: status_code,
           body: "from http"
         }}
      end
    )
  end

  def mock_fabl_with(status_code) do
    Clients.HTTPMock
    |> expect(
      :execute,
      fn %Belfrage.Clients.HTTP.Request{
           method: :get,
           url: "https://fabl.test.api.bbci.co.uk/module/example-module"
         },
         :Fabl ->
        {
          :ok,
          %Belfrage.Clients.HTTP.Response{
            status_code: status_code,
            body: "from fabl"
          }
        }
      end
    )
  end

  def mock_webcore_with(status_code) do
    expect(Clients.LambdaMock, :call, fn _role_arn = @arn,
                                         _lambda_func = "arn:aws:lambda:eu-west-1:123456:function:a-lambda-function",
                                         _payload = %{
                                           httpMethod: "GET",
                                           path: "/_web_core"
                                         },
                                         _request_id = "will-the-webcore-request",
                                         _opts ->
      {:ok,
       %{
         "headers" => %{},
         "statusCode" => status_code,
         "body" => "<h1>Hello from the Lambda!</h1>"
       }}
    end)
  end

  describe "Cascade service with a single request" do
    test "gets a response from http service" do
      mock_http_with(200)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "from http"
               }
             } = Cascade.dispatch([@http_struct])
    end

    test "gets a response from fabl service" do
      mock_fabl_with(200)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "from fabl"
               }
             } = Cascade.dispatch([@fabl_struct])
    end

    test "gets a response from webcore service" do
      mock_webcore_with(200)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "<h1>Hello from the Lambda!</h1>"
               }
             } = Cascade.dispatch([@webcore_struct])
    end
  end

  describe "Cascade Service with multiple requests" do
    test "returns the first response, as it was successful" do
      mock_http_with(200)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "from http"
               }
             } = Cascade.dispatch([@http_struct, @fabl_struct])
    end

    test "returns the second response, as the first one returned a 404" do
      mock_webcore_with(404)
      mock_fabl_with(200)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "from fabl"
               }
             } = Cascade.dispatch([@webcore_struct, @fabl_struct])
    end

    test "returns a 404, as all of the responses returned a 404" do
      mock_http_with(404)
      mock_fabl_with(404)
      mock_webcore_with(404)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 404,
                 body: ""
               }
             } = Cascade.dispatch([@http_struct, @fabl_struct, @webcore_struct])
    end
  end
end
