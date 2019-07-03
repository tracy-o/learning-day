defmodule ExAwsMock do
  defmodule STS do
    def assume_role("webcore-lambda-role-arn", _role_name) do
      :assume_role_successfully
    end

    def assume_role(_wrong_role, _role_name) do
      :fail_to_assume
    end
  end

  defmodule Lambda do
    def invoke("presentation-lambda", _payload, _headers) do
      :invoke_successfully
    end

    def invoke(_wrong_function, _payload, _headers) do
      :fail_to_invoke
    end
  end

  def request(:assume_role_successfully, _opts \\ []) do
    {
      :ok,
      %{
        body: %{
          session_token: "good_token",
          access_key_id: "good_key_id",
          secret_access_key: "good_secret_key"
        }
      }
    }
  end

  def request(:fail_to_assume, _opts), do: {:error, {:http_error, 403, %{code: "AccessDenied"}}}

  def request(:fail_to_invoke, _opts) do
    {:error,
     {:http_error, 404,
      %{
        body:
          "{\"Message\":\"Function not found: arn:aws:lambda:eu-west-1:134209033928:function:test-belfrage-fake-origin-main-LambdaFunction-W0UE8751BFOO\",\"Type\":\"User\"}"
      }}}
  end

  def request(:invoke_successfully, _opts), do: {:ok, "<h1>A Page</h1>"}
end
