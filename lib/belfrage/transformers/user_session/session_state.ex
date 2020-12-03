defmodule Belfrage.Transformers.UserSession.SessionState do
  @idcta_flagpole Application.get_env(:belfrage, :flagpole)

  def category(cookies) do
    cond do
      not Belfrage.Dial.state(:personalisation) -> :personalisation_disabled
      not @idcta_flagpole.state() -> :personalisation_disabled
      true -> session_state(cookies)
    end
  end

  defp session_state(cookies) do
    case cookies do
      %{"ckns_atkn" => _ckns_atkn, "ckns_id" => _ckns_id} -> :auth_provided
      %{"ckns_atkn" => _ckns_atkn} -> :only_auth_token
      %{"ckns_id" => _ckns_id} -> :only_identity_token
      %{} -> :no_auth_provided
    end
  end
end
