defmodule BelfrageWeb.WebCoreRoutes do
  @moduledoc """
  Call Belfrage.handle with the Struct
  """

  alias BelfrageWeb.{View, StructAdapter}

  @belfrage Application.get_env(:belfrage, :belfrage, Belfrage)

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> StructAdapter.adapt()
    |> @belfrage.handle()
    |> View.render(conn)
  end
end
