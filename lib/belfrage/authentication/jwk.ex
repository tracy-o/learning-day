defmodule Belfrage.Authentication.JWK do
  use Agent

  @static_keys_filenames %{
    "https://access.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_live.json",
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_test.json",
    "https://access.stage.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_stage.json",
    "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri" => "jwk_int.json"
  }

  def start_link(opts \\ []) do
    static_keys =
      Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
      |> static_keys_file_name()
      |> read_static_keys()

    Agent.start_link(fn -> static_keys end, name: Keyword.get(opts, :name, __MODULE__))
  end

  def get(agent \\ __MODULE__, alg, kid) do
    key =
      agent
      |> Agent.get(& &1)
      |> Enum.find(fn key -> key["alg"] == alg && key["kid"] == kid end)

    if key do
      {:ok, alg, key}
    else
      Belfrage.Event.record(:log, :error, %{
        msg: "Public key not found",
        kid: kid,
        alg: alg
      })

      {:error, :public_key_not_found}
    end
  end

  def update(agent \\ __MODULE__, keys) do
    Agent.update(agent, fn _current_keys -> keys end)
  end

  def read_static_keys(file_name) do
    :belfrage
    |> Application.app_dir("priv/static/#{file_name}")
    |> File.read!()
    |> Jason.decode!()
    |> Map.fetch!("keys")
  end

  defp static_keys_file_name(uri) do
    if Mix.env() in ~w(test end_to_end)a do
      "jwk_fixtures.json"
    else
      Map.fetch!(@static_keys_filenames, uri)
    end
  end
end
