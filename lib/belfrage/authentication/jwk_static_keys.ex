defmodule Belfrage.Authentication.JwkStaticKeys do
  defmacro __using__(opts) do
    quote do
      @before_compile Belfrage.Authentication.JwkStaticKeys

      jwk_static_keys =
        [
          "priv/static/",
          Keyword.get(unquote(opts), :uri, Application.get_env(:belfrage, :authentication)["account_jwk_uri"])
          |> Crimpex.signature()
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
end
