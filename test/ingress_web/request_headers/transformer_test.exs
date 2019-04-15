defmodule IngressWeb.RequestHeaders.TransformerTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.RequestHeaders.Transformer

  describe "call" do
    test "sets BBC headers in the conn" do
      conn = conn("get", "/", "") |> put_req_header("x-bbc-edge-country", "gb")

      assert Transformer.call(conn, []).private == %{
               bbc_headers: %{cache: false, country: "gb", host: nil}
             }
    end
  end
end
