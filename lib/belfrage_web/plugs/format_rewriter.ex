defmodule BelfrageWeb.Plugs.FormatRewriter do
  def init(opts), do: opts

  def call(conn = %Plug.Conn{request_path: request_path}, _opts) do
    cond do
      ends_with_format?(request_path) -> rewrite_format(conn)
      true -> conn
    end
  end

  defp rewrite_format(conn = %Plug.Conn{path_info: path_info}) do
    last_segment = path_info |> List.last() |> String.split(".")

    case last_segment do
      [ _ ] -> conn
      [ segment, format ] ->
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

  defp ends_with_format?(request_path) do
    String.match?(request_path, ~r/\.\w*$/)
  end
end
