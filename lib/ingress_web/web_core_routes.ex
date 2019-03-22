defmodule IngressWeb.WebCoreRoutes do
  @moduledoc """
  Call Ingress.handle with the Struct
  """

  alias IngressWeb.{View, StructAdapter}

  @ingress Application.get_env(:ingress, :ingress, Ingress)

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> StructAdapter.adapt()
    |> @ingress.handle()
    |> View.render(conn)
  end
end
