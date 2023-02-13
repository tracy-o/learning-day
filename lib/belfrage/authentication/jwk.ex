defmodule Belfrage.Authentication.JWK do
  require Logger
  use Agent

  @static_keys_filenames %{
    "https://access.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_live.json",
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_test.json",
    "https://access.stage.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_stage.json",
    "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_int.json"
  }

  def start_link(opts \\ []) do
    Agent.start_link(fn -> read_static_keys() end, name: Keyword.get(opts, :name, __MODULE__))
  end

  def get(agent \\ __MODULE__, alg, kid) do
    key =
      agent
      |> Agent.get(& &1)
      |> Enum.find(fn key -> key["alg"] == alg && key["kid"] == kid end)

    if key do
      {:ok, alg, key}
    else
      Logger.log(:error, "Public key not found", %{
        kid: kid,
        alg: alg
      })

      {:error, :public_key_not_found}
    end
  end

  def update(agent \\ __MODULE__, keys) when is_list(keys) do
    Agent.update(agent, fn _current_keys -> keys end)
  end

  def read_static_keys(file_name \\ static_keys_file_name()) do
    :belfrage
    |> Application.app_dir("priv/static/#{file_name}")
    |> File.read!()
    |> Jason.decode!()
    |> Map.fetch!("keys")
  end

  defp static_keys_file_name() do
    if Mix.env() == :test do
      "jwk_fixtures.json"
    else
      Map.fetch!(@static_keys_filenames, Application.get_env(:belfrage, :authentication)["account_jwk_uri"])
    end
  end
end
