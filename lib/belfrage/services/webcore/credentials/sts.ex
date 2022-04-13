defmodule Belfrage.Services.Webcore.Credentials.STS do
  @moduledoc """
  This module gets credentials for accessing the Webcore lambda by assuming the
  configured IAM role.
  """
  require Logger

  alias Belfrage.{AWS, Event, Metrics}
  @aws Application.get_env(:belfrage, :aws)

  def get() do
    request = AWS.STS.assume_role(Application.get_env(:belfrage, :webcore_lambda_role_arn), "webcore_session")
    result = Metrics.duration([:request, :assume_webcore_lambda_role], fn -> @aws.request(request) end)

    case result do
      {:ok, %{body: credentials}} ->
        {:ok, struct(AWS.Credentials, credentials)}

      {:error, error} ->
        error_data =
          case error do
            {:http, status_code, response} ->
              %{
                message: "Failed to assume role",
                status: status_code,
                response: response
              }

            _ ->
              %{
                message: "Failed to assume role",
                error: error
              }
          end

        Logger.log(:error, "", error_data)
        Event.record(:metric, :increment, "clients.lambda.assume_role_failure")

        {:error, :failed_to_fetch_credentials}
    end
  end
end
