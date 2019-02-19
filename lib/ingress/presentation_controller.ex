defmodule Ingress.PresentationController do
  import Plug.Conn

  alias Ingress.ErrorView

  @paths [
    "/",
    "/news",
    "/sport",
    "/weather",
    "/bitesize",
    "/cbeebies",
    "/dynasties",
    "/web/shell"
  ]

  def init(options), do: options

  def call(%{request_path: request_path} = conn, _opts) when request_path in @paths do
    {instance_role_name, lambda_role_arn, lambda} = invoke_lambda_options()

    function_payload = %{
      path: conn.request_path
    }

    {200, resp} = Ingress.handle(instance_role_name, lambda_role_arn, lambda, function_payload)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp["body"])
  end

  def call(conn, _opts) do
    conn
    |> ErrorView.render(404)
  end

  defp invoke_lambda_options do
    {
      System.get_env("INSTANCE_ROLE_NAME"),
      Application.fetch_env!(:ingress, :lambda_presentation_role),
      Application.fetch_env!(:ingress, :lambda_presentation_layer)
    }
  end
end
