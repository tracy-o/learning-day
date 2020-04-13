defmodule BelfrageWeb.Plugs.FormatRewriter do
  @moduledoc """
  This Plug is used to solve a shortcoming of Plug.Conn.
  Currently the Plug framework does not seem to handle a matcher like `get "/about-ext/:id.json"` as you'd get an exception:

  ```
  (Plug.Router.InvalidSpecError) :identifier in routes must be made of letters, numbers and underscores
  ```

  This Plug solve this by rewriting requests for `/about-ext/123.json` so that can match:

  ```
  get "/about-ext/:id/.json"
  ```

  Thanks to the Routefile DSL users can still use a familiar:

  ```
  handle "/sport/cricket/teams/:team.app", using: "MySpec", examples: ["/sport/cricket/teams/india.app"]
  ```

  The DSL will take care of rewriting the matcher to: `"/sport/cricket/teams/:team/.app"`
  See also `BelfrageWeb.Rewriter`

  This hijack of the request_info solves the matching and remain invisible in the Belfrage Struct where only the unmodified request_path is passed.

  """

  def init(opts), do: opts

  def call(conn = %Plug.Conn{path_info: path_info}, _opts) do
    path_info
    |> List.last()
    |> String.split(".")
    |> rewrite_format(conn)
  end

  defp rewrite_format([_], conn), do: conn

  defp rewrite_format([segment, format], conn = %Plug.Conn{path_info: path_info}) do
    rewritten_path_info = path_info
    |> List.replace_at(-1, segment)
    |> List.insert_at(-1, "." <> format)

    %{
      conn |
      path_info: rewritten_path_info,
      path_params: Map.merge(conn.path_params, %{"format" => format})
    }
  end
end
