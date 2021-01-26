defmodule Belfrage.Authentication.JwkStaticKeys do
  defmacro __using__(_opts) do
    quote do
      import Belfrage.Authentication.JwkStaticKeys
      @before_compile Belfrage.Authentication.JwkStaticKeys

      jwk_static_keys =
        [
          "priv/static/",
          Application.get_env(:belfrage, :authentication)["account_jwk_uri"] |> get_filename()
        ]
        |> IO.iodata_to_binary()
        |> File.read!()
        |> Jason.decode!()

      Module.put_attribute(__MODULE__, :jwk_static_keys, jwk_static_keys)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_static_keys(), do: @jwk_static_keys
    end
  end

  def get_filename("https://access.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "jwk_live.json"
  def get_filename("https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "jwk_test.json"
  def get_filename("https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri"), do: "jwk_int.json"
  def get_filename(_uri), do: raise("")
end
