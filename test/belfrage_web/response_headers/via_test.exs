defmodule BelfrageWeb.ResponseHeaders.ViaTest do
  use ExUnit.Case
  use Plug.Test

  import ExUnit.CaptureLog
  alias BelfrageWeb.ResponseHeaders.Via
  alias Belfrage.Struct

  test "when upstream does not set a Via header" do
    input_conn = conn(:get, "/")
    struct = %Struct{}

    output_conn = Via.add_header(input_conn, struct)

    assert ["1.1 Belfrage"] == get_resp_header(output_conn, "via")
  end

  test "when upstream does set a Via header" do
    input_conn = conn(:get, "/")
    struct = %Struct{response: %Struct.Response{headers: %{"via" => "Upstream"}}}

    output_conn = Via.add_header(input_conn, struct)

    assert ["Upstream, 1.1 Belfrage"] == get_resp_header(output_conn, "via")
  end

  test "when http protocol isn't recognised, the protocol prefix is still removed" do
    input_conn = conn(:get, "/") |> Plug.Test.put_http_protocol(:"HTTP/3.7")
    struct = %Struct{}

    output_conn = Via.add_header(input_conn, struct)

    assert ["3.7 Belfrage"] == get_resp_header(output_conn, "via")
  end

  test "when http protocol is 1.0" do
    fun = fn ->
      input_conn = conn(:get, "/") |> Plug.Test.put_http_protocol(:"HTTP/1.0")
      struct = %Struct{}
      output_conn = Via.add_header(input_conn, struct)
      assert ["1.0 Belfrage"] == get_resp_header(output_conn, "via")
    end

    assert capture_log(fun) =~ ""
  end
end
