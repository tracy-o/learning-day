defmodule IngressWeb.WebCoreRoutes do
  @moduledoc """
  Build the loop name

  Build initial Struct
  Call Ingress.handle with the Struct
  """

  alias Ingress.Loop
  alias IngressWeb.{View, StructAdapter}

  use IngressWeb, :business_adapter

  def init(options), do: options

  def call(conn, _opts) do
    # [product, page_type, resource_id] = segments = get_route_values(conn)

    get_route_values(conn)
    |> Loop.name_for()
    |> StructAdapter.adapt(conn)
    |> ingress().handle()
    |> View.render(conn)
  end

  defp get_route_values(conn) do
    case conn.path_info do
      [product] -> [product, "homepage", nil]
      [product, page_type] -> [product, page_type, nil]
      [product, page_type, resource_id] -> [product, page_type, resource_id]
    end
  end
end
