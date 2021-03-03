defmodule Belfrage.Authentication.Validator.Expiry do
  def valid?(threshold, expiry) do
    expiry > Joken.current_time() + threshold
  end
end
