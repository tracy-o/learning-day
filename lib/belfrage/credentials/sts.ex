defmodule Belfrage.Credentials.STS do
  @behaviour Belfrage.Behaviours.CredentialStrategy
  @aws_client Application.get_env(:belfrage, :aws_client)

  @impl true
  def refresh_credential(arn, session_name) do
    assume_result = @aws_client.STS.assume_role(arn, session_name)
      |> @aws_client.request()
      |> format_response()

    case assume_result do
      {:ok, credentials} -> {:ok, arn, session_name, credentials}
      {:error, :failed_to_assume_role} -> {:error, :failed_to_fetch_credentials}
    end
  end

  defp format_response(sts_response) do
    case sts_response do
      {:ok, %{body: credentials}} ->
        {:ok, credentials}

      {:error, {:http_error, status_code, response}} ->
        failed_to_assume_role(status_code, response)

      {:error, _} ->
        failed_to_assume_role(nil, nil)
    end
  end

  defp failed_to_assume_role(status_code, response) do
    Stump.log(:error, %{
      message: "Failed to assume role",
      status: status_code,
      response: response
    })

    ExMetrics.increment("clients.lambda.assume_role_failure")
    {:error, :failed_to_assume_role}
  end
end