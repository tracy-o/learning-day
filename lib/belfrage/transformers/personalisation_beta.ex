defmodule Belfrage.Transformers.PersonalisationBeta do
  use Belfrage.Transformers.Transformer
  @authorised_users ["a76ea475-1f67-4b23-95a2-452a364e1aa7", "1a1712e4-596a-4948-8ffb-da6921877a97"]

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{cookies: cookies}}) do
    case is_authorised_user?(cookies["ckns_atkn"]) do
      true -> then(rest, struct)
      false -> then([], struct)
    end
  end

  def is_authorised_user?(token) do
    case Joken.peek_claims(token) do
      {:ok, %{"sub" => uid}} when uid in @authorised_users ->
        true

      {:ok, _claims} ->
        false

      {:error, error_reason} ->
        Stump.log(:error, %{message: "Claims could not be peeked in #{__MODULE__}", error_reason: error_reason})
        false
    end
  end
end
