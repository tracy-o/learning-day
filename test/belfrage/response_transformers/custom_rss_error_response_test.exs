defmodule Belfrage.ResponseTransformers.CustomRssErrorResponseTest do
  use ExUnit.Case

  alias Belfrage.Envelope
  alias Belfrage.ResponseTransformers.CustomRssErrorResponse

  test "Amend FABL response on error" do
    {:ok, envelope} =
      CustomRssErrorResponse.call(%Envelope{
        request: %Envelope.Request{path: "/fd/rss"},
        response: %Envelope.Response{
          http_status: 500,
          body: "Error body from FABL"
        },
        private: %Envelope.Private{
          platform: "Fabl"
        }
      })

    assert envelope.response.body == ""
    assert envelope.response.http_status == 500
  end

  test "Do not amend FABL response on success" do
    {:ok, envelope} =
      CustomRssErrorResponse.call(%Envelope{
        request: %Envelope.Request{path: "/fd/rss"},
        response: %Envelope.Response{
          http_status: 200,
          body: "Some data from FABL"
        },
        private: %Envelope.Private{
          platform: "Fabl"
        }
      })

    assert envelope.response.body == "Some data from FABL"
    assert envelope.response.http_status == 200
  end

  test "Do not amend Karanga responses on failure" do
    {:ok, envelope} =
      CustomRssErrorResponse.call(%Envelope{
        request: %Envelope.Request{path: "/fd/rss"},
        response: %Envelope.Response{
          http_status: 500,
          body: "Some error data from Karanga"
        },
        private: %Envelope.Private{
          platform: "Karanga"
        }
      })

    assert envelope.response.body == "Some error data from Karanga"
    assert envelope.response.http_status == 500
  end
end
