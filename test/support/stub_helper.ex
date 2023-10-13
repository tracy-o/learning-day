defmodule Belfrage.Test.StubHelper do
  alias Belfrage.{Clients, Dials}

  def stub_dial(name, value) do
    stub_dials([{name, value}])
  end

  def stub_dials(dials) do
    Mox.stub(Dials.StateMock, :get_dial, fn name ->
      if Keyword.has_key?(dials, name) do
        {^name, value} = Dials.Config.decode({Atom.to_string(name), dials[name]})
        value
      else
        Dials.State.get_dial(name)
      end
    end)

    :ok
  end

  @doc """
  Makes Lambda and HTTP client return a successful response, which mean that
  any request to an origin will succeed.
  """
  def stub_origins() do
    Mox.stub(Clients.HTTPMock, :execute, fn _request, _platform ->
      {:ok, Clients.HTTP.Response.new(%{status_code: 200, headers: %{}, body: "OK"})}
    end)

    Mox.stub(Clients.LambdaMock, :call, fn _creds, _arn, _payload, _opts ->
      {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
    end)
  end
end
