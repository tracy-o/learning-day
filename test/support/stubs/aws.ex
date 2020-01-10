defmodule Belfrage.AWSStub do
  @behaviour Belfrage.AWS

  def request(_operation, _options \\ [])

  def request(%ExAws.Operation.JSON{service: :lambda}, options) do
    response_body = %{}

    {:ok, %{body: response_body}}
  end

  def request(%ExAws.Operation.Query{service: :sts}, options) do
    response_body = %{
      session_token: "stubbed session token",
      access_key_id: "stubbed access key id",
      secret_access_key: "stubbed secret access key"
    }

    {:ok, %{body: response_body}}
  end
end
