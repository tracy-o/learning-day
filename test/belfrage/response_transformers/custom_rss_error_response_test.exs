defmodule Belfrage.ResponseTransformers.CustomRssErrorResponseTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.ResponseTransformers.CustomRssErrorResponse

  test "Amend FABL response on error" do
    {:ok, struct} =
      CustomRssErrorResponse.call(%Struct{
        request: %Struct.Request{path: "/fd/rss"},
        response: %Struct.Response{
          http_status: 500,
          body: "Error body from FABL"
        },
        private: %Struct.Private{
          platform: "Fabl"
        }
      })

    assert struct.response.body == ""
    assert struct.response.http_status == 500
  end

  test "Do not amend FABL response on success" do
    {:ok, struct} =
      CustomRssErrorResponse.call(%Struct{
        request: %Struct.Request{path: "/fd/rss"},
        response: %Struct.Response{
          http_status: 200,
          body: "Some data from FABL"
        },
        private: %Struct.Private{
          platform: "Fabl"
        }
      })

    assert struct.response.body == "Some data from FABL"
    assert struct.response.http_status == 200
  end

  test "Do not amend Karanga responses on failure" do
    {:ok, struct} =
      CustomRssErrorResponse.call(%Struct{
        request: %Struct.Request{path: "/fd/rss"},
        response: %Struct.Response{
          http_status: 500,
          body: "Some error data from Karanga"
        },
        private: %Struct.Private{
          platform: "Karanga"
        }
      })

    assert struct.response.body == "Some error data from Karanga"
    assert struct.response.http_status == 500
  end
end
