defmodule Belfrage.Authentication.JwkStaticKeys do
  defmacro __using__(opts) do
    quote do
      @before_compile Belfrage.Authentication.JwkStaticKeys

      jwk_filename =
        case Keyword.get(unquote(opts), :uri) do
          uri when not is_nil(uri) -> uri
          _ -> Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
        end
        |> Crimpex.signature()

      jwk_static_keys = File.read!("priv/static/#{jwk_filename}") |> Jason.decode!()

      Module.put_attribute(__MODULE__, :jwk_static_keys, jwk_static_keys)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def get_static_keys(), do: @jwk_static_keys
    end
  end
end
