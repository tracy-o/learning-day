defmodule Belfrage.Test.PersonalisationHelper do
  import Belfrage.Test.StubHelper
  import ExUnit.Callbacks, only: [on_exit: 1]

  alias Plug.Conn
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Request
  alias Fixtures.AuthToken

  @token AuthToken.valid_access_token()

  @doc """
  Make the passed request authenticated. Accepts a %Envelope{}, %Envelope.Request{}
  or %Plug.Conn{} so can be used in unit and end-to-end tests.
  """
  def authenticate_request(envelope = %Envelope{}) do
    Envelope.add(envelope, :request, authenticate_request(envelope.request))
  end

  def authenticate_request(request = %Request{}) do
    %Request{request | raw_headers: Map.put(request.raw_headers, "x-id-oidc-signedin", "1")}
  end

  def authenticate_request(conn = %Conn{}) do
    Conn.put_req_header(conn, "x-id-oidc-signedin", "1")
  end

  @doc """
  Make the passed request unauthenticated. Accepts a %Envelope{}, %Envelope.Request{}
  or %Plug.Conn{} so can be used in unit and end-to-end tests.
  """
  def deauthenticate_request(envelope = %Envelope{}) do
    Envelope.add(envelope, :request, deauthenticate_request(envelope.request))
  end

  def deauthenticate_request(request = %Request{}) do
    %Request{request | raw_headers: Map.put(request.raw_headers, "x-id-oidc-signedin", "0")}
  end

  def deauthenticate_request(conn = %Conn{}) do
    Conn.put_req_header(conn, "x-id-oidc-signedin", "0")
  end

  @doc """
  Make the passed request authenticated and personalised by adding a token
  cookie. Accepts a %Envelope{}, %Envelope.Request{} and %Plug.Conn so can be used
  in unit and end-to-end tests.
  """
  def personalise_request(request, token \\ AuthToken.valid_access_token())

  def personalise_request(envelope = %Envelope{}, token) do
    Envelope.add(envelope, :request, personalise_request(envelope.request, token))
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

  def personalise_app_request(data, token \\ @token)

  def personalise_app_request(envelope = %Envelope{}, token) do
    Envelope.add(envelope, :request, personalise_app_request(envelope.request, token))
  end

  def personalise_app_request(request = %Request{}, token) do
    %Request{
      request
      | raw_headers: %{
          "authorization" => "Bearer #{token}",
          "x-authentication-provider" => "idv5"
        }
    }
  end

  def personalise_app_request(conn = %Conn{}, token) do
    conn
    |> Conn.put_req_header("authorization", "Bearer #{token}")
    |> Conn.put_req_header("x-authentication-provider", "idv5")
  end

  def unpersonalise_app_request(envelope = %Envelope{}) do
    Envelope.add(envelope, :request, unpersonalise_app_request(envelope.request))
  end

  def unpersonalise_app_request(request = %Request{}) do
    %Request{request | raw_headers: Map.drop(request.raw_headers, ["authorization"])}
  end

  def unpersonalise_app_request(conn = %Conn{}) do
    Conn.delete_req_header(conn, "authorization")
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

  @doc """
  Resets the BBCID Agent by terminating and restarting the GenServer
  """
  def reset_bbc_id_on_exit(context) do
    on_exit(fn ->
      :ok = Supervisor.terminate_child(Belfrage.Authentication.Supervisor, Belfrage.Authentication.BBCID)
      {:ok, _pid} = Supervisor.restart_child(Belfrage.Authentication.Supervisor, Belfrage.Authentication.BBCID)
    end)

    context
  end
end
