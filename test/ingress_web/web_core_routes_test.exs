defmodule IngressWeb.WebCoreRoutesTest do
  use ExUnit.Case
  use Plug.Test

  alias Ingress.Struct
  alias IngressWeb.Router
  alias Test.Support.StructHelper

  import Mox
  setup :verify_on_exit!
  setup :set_mox_global

  @struct_after_ingress StructHelper.build(
                          response: %{
                            http_status: 200,
                            body: "<p>Hello</p>"
                          }
                        )

  setup do
    Application.put_env(:ingress, :ingress, IngressMock)

    on_exit(fn ->
      Application.put_env(:ingress, :ingress, Ingress)
    end)
  end

  describe "valid web core route" do
    test "returns content provided by ingress" do
      IngressMock
      |> expect(:handle, fn {"_ingress_homepage", _struct} -> @struct_after_ingress end)

      conn = conn(:get, "/_ingress")
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Hello</p>"
             } = sent_resp(conn)
    end
  end
end
