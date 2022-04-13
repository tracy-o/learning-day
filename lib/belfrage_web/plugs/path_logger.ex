defmodule BelfrageWeb.Plugs.PathLogger do
  @moduledoc """
  Attaches the path of the request to the logger,
  so the path associated with any log can be seen.
  """

  def init(opts), do: opts

  def call(conn = %{request_path: path}, _opts) do
    Logger.metadata(path: path)
    conn
  end
end
