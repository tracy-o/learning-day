defmodule Belfrage.Test.PersonalisationHelper do
  alias Plug.Conn
  alias Belfrage.Struct
  alias Belfrage.Struct.Request
  alias Fixtures.AuthToken

  @doc """
  Make the passed request authenticated. Accepts a %Struct{}, %Struct.Request{}
  or %Plug.Conn{} so can be used in unit and end-to-end tests.
  """
  def authenticate_request(struct = %Struct{}) do
    Struct.add(struct, :request, authenticate_request(struct.request))
  end

  def authenticate_request(request = %Request{}) do
    %Request{request | raw_headers: Map.put(request.raw_headers, "x-id-oidc-signedin", "1")}
  end

  def authenticate_request(conn = %Conn{}) do
    Conn.put_req_header(conn, "x-id-oidc-signedin", "1")
  end

  @doc """
  Make the passed %Plug.Conn request authenticated and personalised
  """
  def personalise_request(conn = %Conn{}, token \\ AuthToken.valid_access_token()) do
    conn
    |> authenticate_request()
    |> Conn.put_req_header("cookie", "ckns_atkn=#{token}")
  end
end
