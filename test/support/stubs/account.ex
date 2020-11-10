defmodule Belfrage.Clients.AccountStub do
  @behaviour Belfrage.Clients.Account

  @impl true
  def get_jwk_keys() do
    {:ok,
     %{
       "keys" => [
         %{
           "kty" => "EC",
           "kid" => "SOME_EC_KEY_ID",
           "crv" => "P-256",
           "x" => "EVs_o5-uQbTjL3chynL4wXgUg2R9q9UU8I5mEovUf84",
           "y" => "kGe5DgSIycKp8w9aJmoHhB1sB3QTugfnRWm5nU_TzsY",
           "alg" => "ES256",
           "use" => "sig"
         }
       ]
     }}
  end
end
