defmodule Belfrage.Plug.AccessLogger do
  require Logger
  alias Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts), do: Keyword.get(opts, :level, :info)

  @impl true
  def call(conn, level) do
    Conn.register_before_send(conn, fn conn ->
      %{
        method: method,
        request_path: request_path,
        query_string: query_string,
        status: status
      } = conn

      Logger.log(
        level,
        "",
        access: true,
        method: method,
        request_path: request_path,
        query_string: query_string,
        status: status
      )

      conn
    end)
  end
end
