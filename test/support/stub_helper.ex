defmodule Belfrage.Test.StubHelper do
  @doc """
  Stub a single dial. The rest of the dials will return default values. This
  function will overwrite any previously stubbed dials. If you need to stub
  multiple dials at once use `stub_dials/1` instead.
  """
  def stub_dial(name, value) do
    stub_dials([{name, value}])
  end

  @doc """
  Stub multiple dials. The rest of the dials will return default values. This
  function will overwrite any previously stubbed dials.
  """
  def stub_dials(dials) do
    Mox.stub(Belfrage.Dials.ServerMock, :state, fn dial_name ->
      if Keyword.has_key?(dials, dial_name) do
        transform_dial_value(dial_name, dials[dial_name])
      else
        Belfrage.Dials.LiveServer.state(dial_name)
      end
    end)
  end

  defp transform_dial_value(name, value) do
    Application.get_env(:belfrage, :dial_handlers)
    |> Map.fetch!(to_string(name))
    |> apply(:transform, [value])
  end

  @doc """
  Makes Lambda and HTTP client return a successful response, which mean that
  any request to an origin will succeed.
  """
  def stub_origins() do
    Mox.stub(Belfrage.Clients.HTTPMock, :execute, fn request, _platform ->
      if String.contains?(request.url, "/preview/module/spike-ares-asset-identifier") do
        {:ok,
         Belfrage.Clients.HTTP.Response.new(%{
           status_code: 200,
           headers: %{},
           body: "{\"data\": {\"section\": \"business\", \"assetType\": \"ABC\"}}"
         })}
      else
        {:ok, Belfrage.Clients.HTTP.Response.new(%{status_code: 200, headers: %{}, body: "OK"})}
      end
    end)

    Mox.stub(Belfrage.Clients.LambdaMock, :call, fn _creds, _arn, _payload, _opts ->
      {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
    end)
  end
end
