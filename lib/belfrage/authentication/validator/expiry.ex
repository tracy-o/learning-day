defmodule Belfrage.Authentication.Validator.Expiry do
  @callback valid?(non_neg_integer(), non_neg_integer()) :: boolean()

  def valid?(threshold, expiry) do
    expiry > Joken.current_time() + threshold
  end
end
