defmodule BelfrageWeb.ResponseHeaders.ViaTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.ResponseHeaders.Via
  alias Belfrage.Struct

  test "when upstream does not set a Via header" do
    input_conn = conn(:get, "/")
    struct = %Struct{}

    output_conn = Via.add_header(input_conn, struct)

    assert ["HTTP/1.1 Belfrage"] == get_resp_header(output_conn, "via")
  end

  test "when upstream does set a Via header" do
    input_conn = conn(:get, "/")
    struct = %Struct{response: %Struct.Response{headers: %{"via" => "Upstream"}}}

    output_conn = Via.add_header(input_conn, struct)

    assert ["HTTP/1.1 Belfrage, Upstream"] == get_resp_header(output_conn, "via")
  end
end
