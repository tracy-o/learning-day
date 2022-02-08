defmodule Belfrage.Test.PersonalisationHelper do
  import Belfrage.Test.StubHelper

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
  Make the passed request unauthenticated. Accepts a %Struct{}, %Struct.Request{}
  or %Plug.Conn{} so can be used in unit and end-to-end tests.
  """
  def deauthenticate_request(struct = %Struct{}) do
    Struct.add(struct, :request, deauthenticate_request(struct.request))
  end

  def deauthenticate_request(request = %Request{}) do
    %Request{request | raw_headers: Map.put(request.raw_headers, "x-id-oidc-signedin", "0")}
  end

  def deauthenticate_request(conn = %Conn{}) do
    Conn.put_req_header(conn, "x-id-oidc-signedin", "0")
  end

  @doc """
  Make the passed request authenticated and personalised by adding a token
  cookie. Accepts a %Struct{}, %Struct.Request{} and %Plug.Conn so can be used
  in unit and end-to-end tests.
  """
  def personalise_request(request, token \\ AuthToken.valid_access_token())

  def personalise_request(struct = %Struct{}, token) do
    Struct.add(struct, :request, personalise_request(struct.request, token))
  end

  def personalise_request(request = %Request{}, token) do
    request
    |> authenticate_request()
    |> struct!(cookies: Map.put(request.cookies, "ckns_atkn", token))
  end

  def personalise_request(conn = %Conn{}, token) do
    conn
    |> authenticate_request()
    |> Conn.put_req_header("cookie", "ckns_atkn=#{token}")
  end

  @doc """
  Stubs the personalisation dial to be 'on'.
  """
  def enable_personalisation() do
    stub_dial(:personalisation, "on")
  end

  @doc """
  Stubs the personalisation dial to be 'off'.
  """
  def disable_personalisation() do
    stub_dial(:personalisation, "off")
  end
end
